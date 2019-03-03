# site_bchristianv::profile::base
#
# Apply a base configuration to all systems with ability to selectively
# disable management of certain configuraitons using feature flags.
#
# @summary Apply a base configuration to all systems.
#
# @example
#   include site_bchristianv::profile::base
#
# @param [Boolean] manage_nameservice_hosts
#   Enable or disable management of /etc/hosts entries.
#   Default value: true.
#
# @param [Boolean] manage_firewalld
#   Enable or disable management of firewalld.
#   Default value: true.
#
# @param [Boolean] manage_selinux
#   Enable or disable management of selinux.
#   Default value: true.
#
# @param [Boolean] manage_yum
#   Enable or disable management of yum.
#   Default value: true.
#
class site_bchristianv::profile::base (
  Boolean $manage_nameservice_hosts = true,
  Boolean $manage_firewalld = true,
  Boolean $manage_selinux = true,
  Boolean $manage_yum = true
){

  if $manage_nameservice_hosts {
    include site_bchristianv::nameservice::hosts
  }

  if $manage_firewalld {
    include firewalld
  }

  if $manage_selinux {
    include selinux
  }

  if $manage_yum {
    include yum
  }

}
