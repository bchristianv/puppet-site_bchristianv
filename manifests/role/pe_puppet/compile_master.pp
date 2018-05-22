# site_bchristianv::role::pe_puppet::compile_master
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::role::pe_puppet::compile_master
class site_bchristianv::role::pe_puppet::compile_master {

  include firewalld

  firewalld_port { 'Puppet Agent - TCP:8140':
    ensure   => present,
    zone     => 'public',
    port     => 8140,
    protocol => 'tcp',
  }

  firewalld_port { 'Puppet Orchestration - TCP:8142':
    ensure   => present,
    zone     => 'public',
    port     => 8142,
    protocol => 'tcp',
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/local_site/pemaster_hiera.yaml',
  }

}

