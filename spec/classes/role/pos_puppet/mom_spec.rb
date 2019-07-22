require 'spec_helper'

describe 'site_bchristianv::role::pos_puppet::mom' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'r10k_git_remote'          => 'foo',
          'control_repo_sshkey_name' => 'github.com',
          'control_repo_sshkey_type' => 'ssh-rsa',
          'control_repo_sshkey_key'  => 'bar',
        }
      end

      it { is_expected.to compile }
    end
  end
end
