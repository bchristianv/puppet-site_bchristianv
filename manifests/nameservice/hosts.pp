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

  host { 'pemom11.localdomain.local':
    host_aliases => ['pemom11'],
    ip           => '10.68.86.11',
  }

  host { 'pecmproxy20.localdomain.local':
    host_aliases => ['pecmproxy20', 'pecm.localdomain.local', 'pecm'],
    ip           => '10.68.86.20',
  }

  host { 'pecm21.localdomain.local':
    host_aliases => ['pecm21'],
    ip           => '10.68.86.21',
  }

  host { 'pecm22.localdomain.local':
    host_aliases => ['pecm22'],
    ip           => '10.68.86.22',
  }

  host { 'peagent31.localdomain.local':
    host_aliases => ['peagent31'],
    ip           => '10.68.86.31',
  }

  host { 'peagent32.localdomain.local':
    host_aliases => ['peagent32'],
    ip           => '10.68.86.32',
  }

}

