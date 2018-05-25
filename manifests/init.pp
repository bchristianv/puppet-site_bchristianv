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
class site_bchristianv (
  Optional[Array] $roles = $facts['site_bchristianv-roles']
){

  if (($roles !~ Array[String]) or ($roles == [])) {
    notify { "No Array[String] type found for class ${title} parameter \$roles - No roles auto-included.": }
    include site_bchristianv::profile::base
  }
  else {
    $roles.each |String $role| {
      if ($role == '') {
        notify { "Empty value found in class ${title} parameter \$roles.": }
        include site_bchristianv::profile::base
      }
      else {
        include $role
      }

    }
  }

}

