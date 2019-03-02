# site_bchristianv::nameservice::hosts
#
# Create local hosts file entries for PE and POS testbed environments lacking
# DNS entries.
#
# @summary Create local hosts file entries for PE and POS testbed environments.
#
# @example
#   include site_bchristianv::nameservice::hosts
#
# @param [Enum] puppet_platform
#   The Puppet platform in use. Either `pe` for Puppet Enterprise, or
#   `pos` for Puppet Open Source.
#   Default value: nil.
#
class site_bchristianv::nameservice::hosts (
  Enum['pe', 'pos'] $puppet_platform
){

  Host {
    ensure => present,
    target => '/etc/hosts',
  }

  case $puppet_platform {
    'pe': {
      host { 'pemom11.localdomain.local':
        host_aliases => ['pemom11', 'pemaster.localdomain.local', 'pemaster'],
        ip           => '172.16.80.11',
      }

      host { 'pecmproxy21.localdomain.local':
        host_aliases => ['pecmproxy21', 'pecm.localdomain.local', 'pecm', 'pemaster.localdomain.local', 'pemaster'],
        ip           => '172.16.80.21',
      }

      host { 'pecm31.localdomain.local':
        host_aliases => ['pecm31'],
        ip           => '172.16.80.31',
      }

      host { 'pecm32.localdomain.local':
        host_aliases => ['pecm32'],
        ip           => '172.16.80.32',
      }

      host { 'peagent41.localdomain.local':
        host_aliases => ['peagent41'],
        ip           => '172.16.80.41',
      }

      host { 'peagent42.localdomain.local':
        host_aliases => ['peagent42'],
        ip           => '172.16.80.42',
      }
    }
    'pos': {  }
  }

}
