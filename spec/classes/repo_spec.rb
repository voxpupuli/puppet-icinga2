require 'spec_helper'

describe('icinga2', :type => :class) do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with manage_repo => true" do
      let(:params) { {:manage_repo => true} }
      case facts[:osfamily]
      when 'Debian'
        it { should contain_apt__source('icinga-stable-release') }
      when 'RedHat'
        let(:facts) { facts.merge({ :osfamily => 'RedHat' }) }
        it { should contain_yumrepo('icinga-stable-release') }
      when 'Suse'
        let(:facts) { facts.merge({ :osfamily => 'Suse' }) }
        it { should contain_zypprepo('icinga-stable-release') }
      end
    end


    context "#{os} with manage_repo => false" do
      let(:params) { {:manage_repo => false} }
      case facts[:osfamily]
      when 'Debian'
        it { should_not contain_apt__source('icinga-stable-release') }
        it { should_not contain_zypprepo('icinga-stable-release') }
      when 'RedHat'
        let(:facts) { facts.merge({ :osfamily => 'RedHat' }) }
        it { should_not contain_yumrepo('icinga-stable-release') }
        it { should_not contain_zypprepo('icinga-stable-release') }
      when 'Suse'
        let(:facts) { facts.merge({ :osfamily => 'Suse' }) }
        it { should_not contain_yumrepo('icinga-stable-release') }
        it { should_not contain_apt__source('icinga-stable-release') }
      end
    end
  end
end
