# site_bchristianv::role::pe_puppet::mom
#
# Manage Puppet Enterprise master of masters settings.
#
# @summary Manage Puppet Enterprise master of masters settings.
#
# @example
#   include site_bchristianv::role::pe_puppet::mom
#
class site_bchristianv::role::pe_puppet::mom {

  include site_bchristianv::profile::pe_puppet::compile_master
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

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/site_bchristianv/role/pe_puppet/mom/hiera.yaml',
    notify => Service['pe-puppetserver'],
  }

}
