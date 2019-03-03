# site_bchristianv::profile::pe_puppet::agent
#
# Manage Puppet Enterprise agent settings and version.
#
# @summary Manage Puppet Enterprise agent settings and version.
#
# @example
#   include site_bchristianv::profile::pe_puppet::agent
#
# @param [String] master
#   Hostname of the puppet master to configure in puppet.conf.
#   Default value: pemaster.localdomain.local
#
# @param [Boolean] manage_version
#   Whether to manage the version of the puppet agent.
#   Default value: false
#
# @param [String] version
#   The version of the puppet agent to configure for if $manage_version is true.
#   Default value: compiling pe server version
#
class site_bchristianv::profile::pe_puppet::agent (
  String $master = 'pemaster.localdomain.local',
  Boolean $manage_version = false,
  String $version = pe_compiling_server_aio_build()
){

  ini_setting { 'main - puppet master':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'server',
    value   => $master,
  }

  if $manage_version {
    class { 'puppet_agent':
      package_version => $version,
      source          => "https://${master}:8140/packages",
    }
  }

}
