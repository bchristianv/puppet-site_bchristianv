require 'spec_helper'

describe 'site_bchristianv::profile::pe_puppet::agent' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      before(:each) do
        Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build,
                                              arity: 0, type: :rvalue) { |_args| '1.2.3-4' }
      end

      it { is_expected.to compile }
    end
  end
end
