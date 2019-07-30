require 'spec_helper'

describe 'site_bchristianv::profile::pos_puppet::compile_master' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
