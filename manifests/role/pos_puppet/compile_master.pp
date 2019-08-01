#
# Manage Puppet Open Source compile master settings.
#
# @summary Manage Puppet Open Source compile master settings.
#
# @example
#   include site_bchristianv::role::pos_puppet::compile_master
#
# @param [Stdlib::Fqdn] mom_fqdn
#   Fully qualified domain name of the puppet master of masters server.
#   Default value: nil.
#
class site_bchristianv::role::pos_puppet::compile_master (
  Stdlib::Fqdn $mom_fqdn
){

  include site_bchristianv::profile::pos_puppet::compile_master

  ini_setting { 'main-ca_server':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'ca_server',
    value   => $mom_fqdn,
  }

  $puppetserver_relationship = {
    require => Class['puppetserver::install'],
    notify  => Service['puppetserver'],
  }

  file_line { 'comment_certificate-authority-service':
    path  => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
    line  => '#puppetlabs.services.ca.certificate-authority-service/certificate-authority-service',
    match => 'puppetlabs.services.ca.certificate-authority-service/certificate-authority-service',
    *     => $puppetserver_relationship,
  }

  file_line { 'uncomment_authority-disabled-service':
    path  => '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
    line  => 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    match => '#puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    *     => $puppetserver_relationship,
  }

  hocon_setting { 'webserver.conf/webserver/ssl-cert':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
    setting => 'webserver.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
    *       => $puppetserver_relationship,
  }

  hocon_setting { 'webserver.conf/webserver/ssl-key':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
    setting => 'webserver.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
    *       => $puppetserver_relationship,
  }

  hocon_setting { 'webserver.conf/webserver/ssl-ca-cert':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/webserver.conf',
    setting => 'webserver.ssl-ca-cert',
    value   => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    *       => $puppetserver_relationship,
  }

  if $facts['pos_infrastructure'] {
    class { 'puppetdb::master::config':
      puppetdb_server                => $mom_fqdn,
      create_puppet_service_resource => false,
    }
  }

}
