# site_bchristianv::test_notify
#
# A simple class that provides a notification message for testing purposes.
# Uses a hiera lookup for message content.
#
# @summary A simple class that provides a notification message.
#
# @example
#   include site_bchristianv::test_notify
#
class site_bchristianv::test_notify {

  notify { "This is a notification from inside the ${title} class.": }

  $hiera_message = lookup('message')
  notify { "Hiera 'message' key value is: ${hiera_message}": }

}
