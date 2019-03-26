#
# Assign puppet role(s) using values from a $site_roles fact, otherwise
# assign a base profile. $site_roles is an array of strings.
#
# Requires:
# - The $site_roles fact be created on managed nodes by another means.
# - Role classes of the same name as the $site_roles value(s) are defined.
#
# @summary Assign puppet role (or roles) using value(s) from a site_roles fact.
#
# @example
#   include site_bchristianv
#
# @param [Optional[Array]] roles
#   A list of site-specific roles to be included in the catalog.
#   Default value: $site_roles.
#
class site_bchristianv (
  Optional[Array] $roles = $facts['site_roles']
){

  include site_bchristianv::profile::base

  if (($roles !~ Array[String]) or ($roles == [])) {
    # notify { "No Array[String] type found for class ${title} parameter \$roles - No roles auto-included.": }
  }
  else {
    $roles.each |String $role| {
      if ($role == '') {
        # notify { "Empty value found in class ${title} parameter \$roles.": }
      }
      else {
        include $role
      }
    }
  }

}
