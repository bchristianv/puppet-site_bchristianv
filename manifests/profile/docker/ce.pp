# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include site_bchristianv::profile::docker::ce
class site_bchristianv::profile::docker::ce (

){
  file { '/etc/yum.repos.d/docker-ce.repo':
    ensure => present,
    source => 'https://download.docker.com/linux/centos/docker-ce.repo',
    group  => 'root',
    owner  => 'root',
    mode   => '0644',
    before => Type[Yumrepo],
  }

  #
  # Configure all docker-ce repos via Hiera
  #

  package {'docker-ce':
    ensure  => present,
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker-ce'],
  }

}
