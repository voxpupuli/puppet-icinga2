require 'spec_helper'

describe Facter::Util::Fact do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context "#{os} icinga2_puppet_hostcert fact" do
        it { expect(Facter.fact(:icinga2_puppet_hostcert).value).to match(%r{/ssl/certs/.*.pem}) }
      end

      context "#{os} icinga2_puppet_hostprivkey fact" do
        it { expect(Facter.fact(:icinga2_puppet_hostprivkey).value).to match(%r{/ssl/private_keys/.*.pem}) }
      end

      context "#{os} icinga2_puppet_localcacert fact" do
        it { expect(Facter.fact(:icinga2_puppet_localcacert).value).to match(%r{/ssl/certs/.*.pem}) }
      end
    end
  end
end
