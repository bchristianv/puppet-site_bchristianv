# site_bchristianv::role::pe_puppet::reverse_proxy
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::role::pe_puppet::reverse_proxy
class site_bchristianv::role::pe_puppet::reverse_proxy {

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

  selinux::port { 'allow-haproxy-bind-8140tcp':
    ensure   => present,
    seltype  => 'http_port_t',
    protocol => 'tcp',
    port     => 8140,
    before   => [Haproxy::Backend['pe8140_back'], Haproxy::Frontend['pe8140_front']]
  }

  selinux::port { 'allow-haproxy-bind-8142tcp':
    ensure   => present,
    seltype  => 'http_port_t',
    protocol => 'tcp',
    port     => 8142,
    before   => [Haproxy::Backend['pe8142_back'], Haproxy::Frontend['pe8142_front']]
  }

  class { 'haproxy':
    merge_options    => true,
    defaults_options => {
      'stats'   => undef,
      'mode'    => 'http',
      'log'     => 'global',
      'option'  => [
        'httplog',
        'dontlognull',
        'http-server-close',
        'redispatch',
        # 'forwardfor except 127.0.0.0/8',
      ],
      'retries' => '3',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'http-keep-alive 10s',
        'check 10s',
      ],
      'maxconn' => '3000',
    },
  }

  haproxy::frontend { 'pe8140_front':
    ipaddress => '*',
    ports     => '8140',
    options   => [
      { 'mode'   => 'tcp' },
      { 'option' => [
        'tcplog',
        ],
      },
      # { 'stats' => 'uri /haproxy?stats' },
      { 'default_backend' => 'pe8140_back' },
    ],
  }

  haproxy::backend { 'pe8140_back':
    options => [
      { 'balance'    => 'roundrobin' },
      { 'mode'       => 'tcp' },
      { 'option'     => [
        'tcplog',
        'httpchk GET /status/v1/simple HTTP/1.0',
        ],
      },
      { 'http-check' => 'expect string running' },
      { 'server'     => 'pemaster11.localdomain.local 10.68.86.11:8140 check check-ssl verify none' },
      { 'server'     => 'pemaster12.localdomain.local 10.68.86.12:8140 check check-ssl verify none' },
    ],
  }

  haproxy::frontend { 'pe8142_front':
    ipaddress => '*',
    ports     => '8142',
    options   => [
      { 'mode'   => 'tcp' },
      { 'option' => [
        'tcplog',
        ],
      },
      # { 'stats' => 'uri /haproxy?stats' },
      { 'default_backend' => 'pe8142_back' },
    ],
  }

  haproxy::backend { 'pe8142_back':
    options => [
      { 'balance'    => 'roundrobin' },
      { 'mode'       => 'tcp' },
      { 'option'     => [
        'tcplog',
        'httpchk GET /status/v1/simple HTTP/1.0',
        ],
      },
      { 'http-check' => 'expect string running' },
      { 'server'     => 'pemaster11.localdomain.local 10.68.86.11:8142 check check-ssl verify none' },
      { 'server'     => 'pemaster12.localdomain.local 10.68.86.12:8142 check check-ssl verify none' },
    ],
  }

}

