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

  host { 'pemasterproxy10.localdomain.local':
    host_aliases => ['pemasterproxy10', 'pemaster.localdomain.local', 'pemaster'],
    ip           => '10.68.86.10',
  }

  host { 'pemaster11.localdomain.local':
    host_aliases => ['pemaster11'],
    ip           => '10.68.86.11',
  }

  host { 'pemaster12.localdomain.local':
    host_aliases => ['pemaster12'],
    ip           => '10.68.86.12',
  }

  host { 'peagent21.localdomain.local':
    host_aliases => ['peagent21'],
    ip           => '10.68.86.21',
  }

  host { 'peagent22.localdomain.local':
    host_aliases => ['peagent22'],
    ip           => '10.68.86.22',
  }

}

