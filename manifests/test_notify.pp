# site_bchristianv::test_notify
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::test_notify
class site_bchristianv::test_notify {

  notify { "This is a notification from inside the ${title} class.": }

  $hiera_message = lookup('message')
  notify { "Hiera 'message' key value is: ${hiera_message}": }

}

