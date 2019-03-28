require 'spec_helper'

describe 'site_bchristianv::role::pe_puppet::reverse_proxy' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:params) do
        {
          'pe_8140_backend_options_servers' => [
            {
              'server' => 'host.localdomain.local 1.2.3.4:8140 check check-ssl verify none',
            },
          ],
          'pe_8142_backend_options_servers' => [
            {
              'server' => 'host.localdomain.local 1.2.3.4:8142 check port 8140 check-ssl verify none',
            },
          ],
        }
      end

      it { is_expected.to compile }
    end
  end
end
