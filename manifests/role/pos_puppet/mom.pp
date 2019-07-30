#
# Manage Puppet Open Source master of masters settings.
#
# @summary Manage Puppet Open Source master of masters settings.
#
# @example
#   include site_bchristianv::role::pos_puppet::mom
#
# @param [Boolean] manage_firewalld
#   Whether to manage the firewalld configuration of ports needed for access to the MoM.
#   Default value: false.
#
class site_bchristianv::role::pos_puppet::mom (
  Boolean $manage_firewalld = false
){

  include site_bchristianv::profile::pos_puppet::compile_master

  if $facts['pos_infrastructure'] {
    if $manage_firewalld {
      include firewalld

      firewalld_port { 'Puppet DB - TCP:8081':
        ensure   => present,
        zone     => 'public',
        port     => 8081,
        protocol => 'tcp',
      }
    }

    hocon_setting { 'ca.conf/certificate-authority/allow-subject-alt-names':
      ensure  => present,
      path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
      setting => 'certificate-authority.allow-subject-alt-names',
      value   => true,
      notify  => Service['puppetserver'],
    }

    class { 'puppetdb':
      manage_firewall => false,
    }

    class { 'puppetdb::master::config': }
  }

}
