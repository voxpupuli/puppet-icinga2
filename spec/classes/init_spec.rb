require 'spec_helper'
describe 'icinga2' do

  context 'with defaults for all parameters' do
    it { should contain_class('icinga2') }
  end
end
