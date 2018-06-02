# Credit to SIMP 'https://github.com/simp/pupmod-simp-simplib'
function site_bchristianv::knockout_value(Array $arg) >> Array {

  $include_array = $arg.filter |$mem_obj| {
    $mem_obj !~ /^--/
  }

  $exclude_filter = $arg.filter |$mem_obj| {
    $mem_obj =~ /^--/
  }

  $exclude_array = $exclude_filter.map |$mem_obj| {
    delete($mem_obj, '--')
  }

  ($include_array - $exclude_array)

}

