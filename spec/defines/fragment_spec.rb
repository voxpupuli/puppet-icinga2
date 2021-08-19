require 'spec_helper'

describe('icinga2::config::fragment', type: :define) do
  let(:title) { 'bar' }

  let(:pre_condition) do
    [
      "class { 'icinga2': }",
    ]
  end

  on_supported_os.each do |os, facts|
    let(:facts) do
      facts
    end

    context "#{os} with content => 'foo, target => '/bar/baz', order => 10" do
      let(:params) do
        {
          content: 'foo',
          target: '/bar/baz',
          order: '10',
        }
      end

      it { is_expected.to contain_concat('/bar/baz') }

      it { is_expected.to contain_concat__fragment('icinga2::config::bar').with({ 'target' => '/bar/baz', 'order' => '10' }).with_content(%r{^foo$}) }
    end
  end
end
