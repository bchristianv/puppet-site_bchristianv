# site_bchristianv
#
# Assign a puppet role (or roles) using values from a site_roles fact. The 
# site_roles fact is an array of strings.
#
# Requires:
# - The site_roles fact be created on managed nodes by another means
# - Role classes of the same name as the site_roles value(s) are available
#
# @summary Assign puppet role (or roles) using value(s) from a site_roles fact.
#
# @example
#   include site_bchristianv
class site_bchristianv {

  $role_classes = $facts['site_roles']

  if ($role_classes !~ Array[String]) {
    notify { 'No Array[String] type value found for $facts[\'site_roles\'] - No roles auto-included.': }
  }
  else {
    $role_classes.each |String $role| {
      if ($role == '') {
        notify { 'Found an empty $facts[\'site_roles\'] value - No roles auto-included.': }
      }
      else {
        include "site_bchristianv::role::${role}"
      }
    }
  }

}
