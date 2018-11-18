# site_bchristianv::nameservice::hosts
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::nameservice::hosts
class site_bchristianv::nameservice::hosts {

  Host {
    ensure => present,
    target => '/etc/hosts',
  }

  host { 'pemom11.cracklecode.local':
    host_aliases => ['pemom11', 'pemaster.cracklecode.local', 'pemaster'],
    ip           => '172.16.80.11',
  }

#  host { 'pecmproxy21.cracklecode.local':
#    host_aliases => ['pecmproxy21', 'pecm.cracklecode.local', 'pecm', 'pemaster.cracklecode.local', 'pemaster'],
#    ip           => '172.16.80.21',
#  }

#  host { 'pecm31.cracklecode.local':
#    host_aliases => ['pecm31'],
#    ip           => '172.16.80.31',
#  }

#  host { 'pecm32.cracklecode.local':
#    host_aliases => ['pecm32'],
#    ip           => '172.16.80.32',
#  }

  host { 'peagent41.cracklecode.local':
    host_aliases => ['peagent41'],
    ip           => '172.16.80.41',
  }

#  host { 'peagent42.cracklecode.local':
#    host_aliases => ['peagent42'],
#    ip           => '172.16.80.42',
#  }

}
