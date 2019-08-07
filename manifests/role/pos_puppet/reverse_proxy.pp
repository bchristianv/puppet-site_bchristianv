#
# Manage reverse-proxy (HAProxy) settings for a Puppet Open Source compile
# master pool.
#
# @summary Manage reverse-proxy (HAProxy) settings for a Puppet Open Source
# compile master pool.
#
# @example
#   include site_bchristianv::role::pos_puppet::reverse_proxy
#
# @param [Array[Hash[String,String]]] pos_8140_backend_options_servers
#   The `server` parameter(s) for the backend server pool listening on port 8140.
#   i.e., the `server` parameter for the `options` array. ex., `[{"server": "cm1.localdomain.local 1.2.3.4:8140"}]`
#   Default value: nil.
#
class site_bchristianv::role::pos_puppet::reverse_proxy (
  Array[Hash[String,String]] $pos_8140_backend_options_servers
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

  selinux::port { 'allow-haproxy-bind-8140tcp':
    ensure   => present,
    seltype  => 'http_port_t',
    protocol => 'tcp',
    port     => 8140,
    before   => [Haproxy::Backend['pos8140_back'], Haproxy::Frontend['pos8140_front']]
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

  haproxy::frontend { 'pos8140_front':
    ipaddress => '*',
    ports     => '8140',
    options   => [
      { 'mode'   => 'tcp' },
      { 'option' => [
        'tcplog',
      ],
      },
      # { 'stats' => 'uri /haproxy?stats' },
      { 'default_backend' => 'pos8140_back' },
    ],
  }

  $pos_8140_backend_options = $backend_options + $pos_8140_backend_options_servers

  haproxy::backend { 'pos8140_back':
    options => $pos_8140_backend_options
  }

}
