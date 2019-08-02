#
# Deploy a Puppet Open Source puppetserver and puppetdb (MoM)
#
# @summary Deploy a Puppet Open Source puppetserver and puppetdb (MoM).
#
# @example
#   bolt plan run site_bchristianv::pos_puppet::deploy_mom \
#                 nodes=puppet.localdomain.local \
#                 manage_pos_release=true \
#                 pos_release_package=https://yum.puppet.com/puppet-release-el-7.noarch.rpm \
#                 manage_github_deploy_key=true \
#                 github_deploy_key_name=puppet_control@puppet.localdomain.local \
#                 github_token='...sometoken...' \
#                 github_user=octocat \
#                 github_project=puppet_control \
#                 -u root -p --no-host-key-check
#
# @param [TargetSpec] nodes
#   The hostname of the system to deploy as a Puppet Open Source puppetserver and puppetdb (MoM).
#   Default value: nil.
#
# @param [Boolean] manage_pos_release
#   Whether to manage the puppet-release package that sets up the puppet package YUM repositories.
#   Default value: false.
#
# @param [Optional[TargetSpec]] pos_release_package
#   The path to the puppet-release package, either local or remote, when `$manage_pos_release` is true.
#   Default value: nil.
#
# @param [Stdlib::Absolutepath] control_repo_private_sshkey
#   The path to use for the control repository private ssh key creation.
#   Will be copied to the `/etc/puppetlabs/puppetserver/ssh directory`.
#   Default value: /root/.ssh/pos_control-id_rsa.
#
# @param [Boolean] manage_github_deploy_key
#   Whether to manage the github deploy key used for the control repository. Only useful for github.com.
#   Default value: false.
#
# @param [Optional[String]] github_deploy_key_name
#   The name to use for the github.com deploy key, when `$manage_github_deploy_key` is true.
#   Default value: nil.
#
# @param [Optional[String]] github_token
#   The token to use for the github.com deploy key creation, when `$manage_github_deploy_key` is true.
#   Default value: nil.
#
# @param [Optional[String]] github_user
#   The user account to use for the github.com deploy key creation, when `$manage_github_deploy_key` is true.
#   Default value: nil.
#
# @param [Optional[String]] github_project
#   The github user's project under which the github.com deploy key will be created,
#   when `$manage_github_deploy_key` is true.
#   Default value: nil.
#
# @param [Optional[TargetSpec]] github_server
#   The github server api endpoint, when `$manage_github_deploy_key` is true.
#   Default value: api.github.com.
#
plan site_bchristianv::pos_puppet::deploy_mom (
  TargetSpec $nodes,
  Boolean $manage_pos_release = false,
  Optional[TargetSpec] $pos_release_package = undef,
  Stdlib::Absolutepath $control_repo_private_sshkey = '/root/.ssh/pos_control-id_rsa',
  Boolean $manage_github_deploy_key = false,
  Optional[String] $github_deploy_key_name = undef,
  Optional[String] $github_token = undef,
  Optional[String] $github_user = undef,
  Optional[String] $github_project = undef,
  Optional[TargetSpec] $github_server = 'api.github.com'
){

  if $manage_pos_release {
    run_task('package', $nodes, { action => 'install', name => $pos_release_package })
  }

  run_task('package', $nodes, { action => 'install', name => 'puppetserver' })
  run_command('/opt/puppetlabs/bin/puppet module install puppet-r10k --version 7.0.0', $nodes)

  run_command(
    "/usr/bin/ssh-keygen -b 4096 -C pos_puppet_control@$(hostname) -N '' -f ${control_repo_private_sshkey}",
    $nodes
  )
  run_command('mkdir -p -m 0700 /etc/puppetlabs/puppetserver/ssh/', $nodes)
  run_command("cp ${control_repo_private_sshkey}* /etc/puppetlabs/puppetserver/ssh/", $nodes)

  $site_roles_fact_file = '/etc/puppetlabs/facter/facts.d/site_roles.json'
  run_command("mkdir -p $(dirname ${site_roles_fact_file})", $nodes)
  run_command(
    "echo -e '{\n\t\"site_roles\": [\"site_bchristianv::role::pos_puppet::mom\"]\n}\n' > ${site_roles_fact_file}",
    $nodes
  )

  apply_prep($nodes)

  apply($nodes) {
    include site_bchristianv

    if $manage_github_deploy_key {
      git_deploy_key { $github_deploy_key_name:
        ensure       => present,
        path         => "${control_repo_private_sshkey}.pub",
        token        => $github_token,
        project_name => "${github_user}/${github_project}",
        server_url   => "https://${github_server}",
        provider     => 'github',
      }
    }

  }

  if $manage_github_deploy_key {
    # The `r10k::deploy` task uses the operating system ruby (#!/usr/bin/env ruby) rather
    # than the puppet aio agent ruby located at /opt/puppetlabs/puppet/bin/ruby
    #run_task( 'r10k::deploy', $nodes)
    run_command('/usr/bin/r10k deploy environment --puppetfile --verbose', $nodes)
  }

  run_task('service', $nodes, { action => 'enable', name => 'puppet'})
  run_task('service', $nodes, { action => 'start', name => 'puppet'})

}
