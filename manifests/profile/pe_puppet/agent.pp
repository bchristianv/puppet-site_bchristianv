# site_bchristianv::profile::pe_puppet::agent
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::profile::pe_puppet::agent
class site_bchristianv::profile::pe_puppet::agent (
  String $pe_master        = 'pemaster.cracklecode.local',
  Boolean $manage_pe_agent = false,
  String $pe_agent_version = pe_compiling_server_aio_build()
){

  ini_setting { 'main - puppet master':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'server',
    value   => $pe_master,
  }

  if $manage_pe_agent {
    class { 'puppet_agent':
      package_version => $pe_agent_version,
      source          => "https://${pe_master}:8140/packages",
    }
  }

}
