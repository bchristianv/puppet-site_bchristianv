#
# Manage reverse-proxy (HAProxy) settings for a Puppet Enterprise compile
# master pool.
#
# @summary Manage reverse-proxy (HAProxy) settings for a Puppet Enterprise
# compile master pool.
#
# @example
#   include site_bchristianv::role::pe_puppet::reverse_proxy
#
# @param [Array[Hash]] pe_8140_backend_options_servers
#   The `server` parameter(s) for the backend server pool listening on port 8140.
#   i.e., the `server` parameter for the `options` array.
#   Default value: nil.
#
# @param [Array[Hash]] pe_8142_backend_options_servers
#   The `server` parameter(s) for the backend server pool listening on port 8142.
#   i.e., the `server` parameter for the `options` array.
#   Default value: nil.
#
class site_bchristianv::role::pe_puppet::reverse_proxy (
  Array $pe_8140_backend_options_servers,
  Array $pe_8142_backend_options_servers
){

  $backend_options = [
    { 'balance'    => 'roundrobin' },
    { 'mode'       => 'tcp' },
    { 'option'     => [
      'tcplog',
      'httpchk GET /status/v1/simple HTTP/1.0',
    ],
    },
    { 'http-check' => 'expect string running' }
  ]

  include firewalld
  include selinux

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

  $pe_8140_backend_options = $backend_options + $pe_8140_backend_options_servers

  haproxy::backend { 'pe8140_back':
    options => $pe_8140_backend_options
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

  $pe_8142_backend_options = $backend_options + $pe_8142_backend_options_servers

  haproxy::backend { 'pe8142_back':
    options => $pe_8142_backend_options
  }

}
