# site_bchristianv::hiera_lookup_not_found
#
# Used in conjunction with site_bchristianv::hiera_lookup_include, will 
# notify that a hiera lookup failed instead of causing a catalog compilation.
#
# @summary Notify that a hiera lookup failed when used with hiera_lookup_include
#
# @example
#   include site_bchristianv::hiera_lookup_not_found
class site_bchristianv::hiera_lookup_not_found {

  notify { 'Hiera was unable to find a key while performing a lookup() function.': }

}
