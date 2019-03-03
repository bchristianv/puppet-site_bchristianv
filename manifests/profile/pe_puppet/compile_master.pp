#
# Manage Puppet Enterprise compile master settings.
#
# @summary Manage Puppet Enterprise compile master settings.
#
# @example
#   include site_bchristianv::profile::pe_puppet::compile_master
#
class site_bchristianv::profile::pe_puppet::compile_master {

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

}
