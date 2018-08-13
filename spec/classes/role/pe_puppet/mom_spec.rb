require 'spec_helper'

describe 'site_bchristianv::role::pe_puppet::mom' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) { 'service { "pe-puppetserver": ensure => running, enable => true, }' }

      it { is_expected.to compile }
    end
  end
end
