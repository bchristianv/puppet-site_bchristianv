# site_bchristianv::role::pe_puppet::compile_master
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::role::pe_puppet::compile_master
class site_bchristianv::role::pe_puppet::compile_master {

  include site_bchristianv::profile::base
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

  puppet_authorization::rule { 'puppetlabs status simple':
    match_request_path    => '/status/v1/simple',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 900,
    path                  => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    notify                => Service['pe-puppetserver'],
  }

}

