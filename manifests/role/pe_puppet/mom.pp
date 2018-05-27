# site_bchristianv::role::pe_puppet::mom
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::role::pe_puppet::mom
class site_bchristianv::role::pe_puppet::mom {

  include site_bchristianv::profile::base
  include firewalld

  firewalld_service { 'Puppet Console - TCP:443':
    ensure  => present,
    service => 'https',
    zone    => 'public',
  }

  firewalld_port { 'Puppet Node Classifier - TCP:4433':
    ensure   => present,
    zone     => 'public',
    port     => 4433,
    protocol => 'tcp',
  }

  firewalld_port { 'Puppet DB - TCP:8081':
    ensure   => present,
    zone     => 'public',
    port     => 8081,
    protocol => 'tcp',
  }

  firewalld_port { 'Puppet Orchestration PCP - TCP:8143':
    ensure   => present,
    zone     => 'public',
    port     => 8143,
    protocol => 'tcp',
  }

  firewalld_port { 'Puppet MCollective - TCP:61613':
    ensure   => present,
    zone     => 'public',
    port     => 61613,
    protocol => 'tcp',
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/site_bchristianv/pemaster_hiera.yaml',
  }

}

