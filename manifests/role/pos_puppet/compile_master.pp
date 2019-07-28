#
# Manage Puppet Open Source compile master settings.
#
# @summary Manage Puppet Open Source compile master settings.
#
# @example
#   include site_bchristianv::role::pos_puppet::compile_master
#
# @param [String] r10k_git_remote
#   The r10k `remote` git control repository source URL setting.
#   Default value: nil.
#
# @param [Stdlib::Host] control_repo_sshkey_name
#   The control repository host name that the sshkey is associated with.
#   Default value: nil.
#
# @param [String] control_repo_sshkey_type
#   The sshkey encryption type in use by the control repository.
#   Default value: nil.
#
# @param [String] control_repo_sshkey_key
#   The control repository sshkey key itself.
#   Default value: nil.
#
# @param [Stdlib::Fqdn] puppet_mom_fqdn
#   Fully qualified domain name of the puppet master of masters server.
#   Default value: nil.
#
# @param [Boolean] manage_firewalld
#   Whether to manage the firewalld configuration of ports needed for access to the MoM.
#   Default value: false.
#
# @param [Array[Stdlib::Fqdn]] dns_alt_names
#   An array of alternale DNS names that the server is allowed to use when serving agents.
#   Default value: ['puppet.localdomain.local', 'puppet'].
#
# @param [String] puppetserver_xms
#   The puppetserver JVM's minimum amount of heap memory it is allowed to request from the OS.
#   Default value: 2g.
#
# @param [String] puppetserver_xmx
#   The puppetserver JVM's maximum amount of heap memory it is allowed to request from the OS.
#   Default value: 2g.
#
# @param [Boolean] use_r10k_rugged_provider
#   Whether to configure r10k to use the `rugged` provider, otherwise uses `git-shell`.
#   Default value: false.
#
# @param [Stdlib::Absolutepath] control_repo_private_sshkey
#   The absolute path to the private sshkey with read access to the control repository.
#   Default value: /root/.ssh/pos_control-id_rsa.
#
class site_bchristianv::role::pos_puppet::compile_master (
  String $r10k_git_remote,
  Stdlib::Host $control_repo_sshkey_name,
  String $control_repo_sshkey_type,
  String $control_repo_sshkey_key,
  Stdlib::Fqdn $puppet_mom_fqdn,
  Boolean $manage_firewalld = false,
  Array[Stdlib::Fqdn] $dns_alt_names = ['puppet.localdomain.local', 'puppet'],
  String $puppetserver_xms = '2g',
  String $puppetserver_xmx = '2g',
  Boolean $use_r10k_rugged_provider = false,
  Stdlib::Absolutepath $control_repo_private_sshkey = '/etc/puppetlabs/puppetserver/ssh/pos_control-id_rsa'
){

  if $manage_firewalld {
    include firewalld

    firewalld_port { 'Puppet Agent - TCP:8140':
      ensure   => present,
      zone     => 'public',
      port     => 8140,
      protocol => 'tcp',
    }
  }

  ini_setting { 'main-ca_server':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'ca_server',
    value   => $puppet_mom_fqdn,
  }

  ini_setting { 'main-dns_alt_names':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'dns_alt_names',
    value   => join($dns_alt_names, ','),
  }

  ini_setting { 'agent-server':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'server',
    value   => $puppet_mom_fqdn,
  }

  file_line { 'comment_certificate-authority-service':
    path  => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
    line  => '#puppetlabs.services.ca.certificate-authority-service/certificate-authority-service',
    match => 'puppetlabs.services.ca.certificate-authority-service/certificate-authority-service',
  }

  file_line { 'uncomment_authority-disabled-service':
    path  => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
    line  => 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    match => '#puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
  }

  service { 'puppet':
    ensure  => running,
    enable  => true,
    require => Ini_setting['main-ca_server','main-dns_alt_names', 'agent-server'],
  }

  file { '/etc/puppetlabs/facter/facts.d/poscm_is_configured.json':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "{\n\t\"poscm_is_configured\": true\n}\n",
    require => Service['puppet'],
  }

  if $facts['poscm_is_configured'] {
    $puppetserver_start = true

    class { 'puppetdb::master::config':
      puppetdb_server                => $puppet_mom_fqdn,
      create_puppet_service_resource => false,
    }
  }
  else {
    $puppetserver_start = false
  }

  class { 'puppetserver':
    start   => $puppetserver_start,
    config  => {
      'java_args' => {
        'xms' => $puppetserver_xms,
        'xmx' => $puppetserver_xmx,
      }
    },
    require => [
      Ini_setting['main-ca_server','main-dns_alt_names', 'agent-server'],
      File_line['comment_certificate-authority-service', 'uncomment_authority-disabled-service'],
    ],
  }

  class { 'puppetserver::hiera::eyaml':
    require => Class['puppetserver::install'],
  }

  # The `rugged` provider requires the following OS packages: cmake, gcc, libssh2-devel >= 1.7.0, openssl-devel
  # and the rugged gem: (/opt/puppetlabs/puppet/bin/gem install rugged)
  # Unfortunately EL 7.x does not have a compatible version of libssh2-devel
  # EL 8.x will have libssh-devel, not libssh2-devel
  if $use_r10k_rugged_provider {
    $git_settings = {
      'provider'    => 'rugged',
      'private_key' => $control_repo_private_sshkey,
    }
  }
  else {
    $git_settings = {}

    file { '/root/.ssh/config':
      ensure  => present,
      content => "Host ${control_repo_sshkey_name}\n\tIdentityFile ${control_repo_private_sshkey}\n",
    }
  }

  class { 'r10k':
    remote       => $r10k_git_remote,
    git_settings => $git_settings,
    require      => Class['puppetserver::install']
  }

  class { 'r10k::mcollective':
    ensure => false,
  }

  sshkey { $control_repo_sshkey_name:
    ensure => present,
    type   => $control_repo_sshkey_type,
    target => '/root/.ssh/known_hosts',
    key    => $control_repo_sshkey_key,
  }

}
