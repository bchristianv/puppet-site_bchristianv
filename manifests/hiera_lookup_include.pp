# site_bchristianv::hiera_lookup_include
#
# Use a hiera lookup to include classes in the catalog.
#
# Provides a default value to prevent failed lookups, which result in a 
# catalog compilation error.
#
# @summary Use a hiera lookup to include classes in the catalog.
#
# @example
#   include site_bchristianv::hiera_lookup_include
class site_bchristianv::hiera_lookup_include {

  lookup('classes', Array[String], 'unique', ['site_bchristianv::hiera_lookup_not_found']).include

}
