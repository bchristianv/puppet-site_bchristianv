#
# Create local `/etc/hosts` entries for environments lacking external DNS.
#
# @summary Create local `/etc/hosts` entries for environments lacking external DNS.
#
# @example Simple include usage
#   include site_bchristianv::nameservice::hosts
#
# @example Hiera parameter lookup
#   ---
#   site_bchristianv::nameservice::hosts::entries:
#     host.localdomain.local:
#       ensure: present
#       host_aliases:
#         - 'host'
#       ip: '1.2.3.4'
#       target: '/etc/hosts'
#     ...
#   include site_bchristianv::nameservice::hosts
#
# @example Resource-like class declaration usage
#   $hosts = {
#     host.localdomain.local: {
#       ensure: present,
#       host_aliases: ['host'],
#       ip: '1.2.3.4',
#       target: '/etc/hosts',
#     },
#     {...}
#   }
#   site_bchristianv::nameservice::hosts { 'namevar':
#     entries => $hosts
#   }
#
# @param [Hash] entries
#   A hash of (host resource) entry names and their parameter key/values. Default value: { }.
#
class site_bchristianv::nameservice::hosts (
  Hash $entries = {}
){

  $entries.each |String $entry, Hash $properties| {
    host { $entry:
      * => $properties,
    }
  }

}
