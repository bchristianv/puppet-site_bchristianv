# site_bchristianv::profile::pe_puppet::agent
#
# Manage Puppet Enterprise agent settings and version.
#
# @summary Manage Puppet Enterprise agent settings and version.
#
# @example
#   include site_bchristianv::profile::pe_puppet::agent
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
