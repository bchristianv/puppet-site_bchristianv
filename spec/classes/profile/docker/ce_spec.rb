require 'spec_helper'

describe 'site_bchristianv::profile::docker::ce' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) { 'yumrepo { "foo": ensure => present, baseurl => "http://host.domain.local", descr => "foo_repo" }' }

      it { is_expected.to compile }
    end
  end
end
