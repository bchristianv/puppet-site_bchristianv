require 'spec_helper'

describe 'site_bchristianv::role::pos_puppet::reverse_proxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
