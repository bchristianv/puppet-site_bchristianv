# site_bchristianv::hiera_lookup_not_found
#
# Used in conjunction with site_bchristianv::hiera_lookup_include as default
# value. Will notify that a hiera lookup failed instead of causing a catalog
# compilation error for a non-existant hiera key.
#
# @summary Notify that a hiera lookup failed when used with hiera_lookup_include
#
# @example
#   include site_bchristianv::hiera_lookup_not_found
#
class site_bchristianv::hiera_lookup_not_found {

  notify { 'Hiera was unable to find a key while performing a lookup() function.': }

}
