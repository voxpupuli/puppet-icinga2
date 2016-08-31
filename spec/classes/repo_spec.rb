require 'spec_helper'
require 'plattforms'

describe('icinga2', :type => :class) do

  # RedHat 6
  context 'with manage_repo => false on RedHat 6' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 6'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on RedHat 6' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 6'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_yumrepo('icinga-stable-release')
    end
  end

  # RedHat 7
  context 'with manage_repo => false on RedHat 7' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on RedHat 7' do
    let(:facts) { IcingaPuppet.plattforms['RedHat 7'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_yumrepo('icinga-stable-release')
    end
  end

  # Centos 6
  context 'with manage_repo => false on Centos 6' do
    let(:facts) { IcingaPuppet.plattforms['Centos 6'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Centos 6' do
    let(:facts) { IcingaPuppet.plattforms['Centos 6'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_yumrepo('icinga-stable-release')
    end
  end

  # Centos 7
  context 'with manage_repo => false on Centos 7' do
    let(:facts) { IcingaPuppet.plattforms['Centos 7'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_yumrepo('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Centos 7' do
    let(:facts) { IcingaPuppet.plattforms['Centos 7'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_yumrepo('icinga-stable-release')
    end
  end

  # Debian wheezy
  context 'with manage_repo => false on Debian wheezy' do
    let(:facts) { IcingaPuppet.plattforms['Debian wheezy'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Debian wheezy' do
    let(:facts) { IcingaPuppet.plattforms['Debian wheezy'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_apt__source('icinga-stable-release').with({
        :release => 'icinga-wheezy'
      })
    end
  end

  # Debian jessie
  context 'with manage_repo => false on Debian jessie' do
    let(:facts) { IcingaPuppet.plattforms['Debian jessie'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Debian jessie' do
    let(:facts) { IcingaPuppet.plattforms['Debian jessie'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_apt__source('icinga-stable-release').with({
        :release => 'icinga-jessie'
      })
    end
  end

  # Ubuntu trusty
  context 'with manage_repo => false on Ubuntu trusty' do
    let(:facts) { IcingaPuppet.plattforms['Ubuntu trusty'] }
    let(:params) { {:manage_repo => false} }
    it do
      should_not contain_apt__source('icinga-stable-release')
    end
  end

  context 'with manage_repo => true on Ubuntu' do
    let(:facts) { IcingaPuppet.plattforms['Ubuntu trusty'] }
    let(:params) { {:manage_repo => true} }
    it do
      should contain_apt__source('icinga-stable-release')
    end
  end

end
