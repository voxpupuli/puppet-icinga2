require 'spec_helper'

facts = {
  kernel: 'Linux',
  os: { family: 'Debian', name: 'Debian' },
}

describe('icinga2::object', type: :define) do
  let(:title) do
    'foo'
  end

  let(:pre_condition) do
    [
      "class { 'icinga2': }",
    ]
  end

  before(:each) do
    # Fake assert_private function from stdlib to not fail within this test
    Puppet::Parser::Functions.newfunction(:assert_private, type: :rvalue) { |args| }
  end

  on_supported_os.each do |os, complete_facts|
    let(:facts) do
      complete_facts
    end

    context "#{os} with object_type => 'foobar'" do
      let(:params) do
        {
          object_type: 'foobar',
          target: '/bar/baz',
          order: '10',
        }
      end

      case facts[:os]['family']
      when 'Debian'
        let(:icinga2_user) { 'nagios' }
        let(:icinga2_group) { 'nagios' }
      when 'Windows'
        let(:icinga2_user) { null }
        let(:icinga2_group) { null }
      else
        let(:icinga2_user) { 'icinga' }
        let(:icinga2_group) { 'icinga' }
      end

      it { is_expected.to contain_concat('/bar/baz').with({ 'owner' => icinga2_user, 'group' => icinga2_group }).that_notifies('Class[icinga2::service]') }

      it { is_expected.to contain_concat__fragment('foo').with({ 'target' => '/bar/baz', 'order' => '10' }).with_content(%r{object foobar "foo" \{}) }

      it { is_expected.to compile }
    end
  end

  context 'with template => true' do
    let(:params) do
      {
        template: true,
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{template foobar "foo" \{}) }
  end

  context "with import => ['bar', 'baz']" do
    let(:params) do
      {
        import: ['bar', 'baz'],
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{import "bar"\n  import "baz"\n}) }
  end

  context "with apply_target => 'Service', object_type => 'Service' (same value)" do
    let(:params) do
      {
        apply_target: 'Service',
        object_type: 'Service',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{must be different}) }
  end

  context "with apply => true, apply_target => 'Host'" do
    let(:params) do
      {
        apply: true,
        apply_target: 'Host',
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{apply foobar \"foo\" to Host \{}) }
  end

  context "with apply => true, apply_target => 'Service'" do
    let(:params) do
      {
        apply: true,
        apply_target: 'Service',
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{apply foobar \"foo\" to Service \{}) }
  end

  context "with apply => 'item in array', prefix => true" do
    let(:params) do
      {
        apply: 'item in array',
        prefix: true,
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{apply foobar \"foo\" for \(item in array\) \{}) }
  end

  context "with apply => 'key => value in hash', prefix => 'some string'" do
    let(:params) do
      {
        apply: 'key => value in hash',
        prefix: 'some string',
        object_type: 'foobar',
        target: '/bar/baz',
        order: '10',
      }
    end

    it { is_expected.to contain_concat__fragment('foo').with_content(%r{apply foobar \"some string\" for \(key => value in hash\) \{}) }
  end
end

on_icinga_objects = {
  ApiUser: 'icinga2::object::apiuser',
  CheckCommand: 'icinga2::object::checkcommand',
  Dependency: 'icinga2::object::dependency',
  Endpoint: 'icinga2::object::endpoint',
  EventCommand: 'icinga2::object::eventcommand',
  Host: 'icinga2::object::host',
  HostGroup: 'icinga2::object::hostgroup',
  Notification: 'icinga2::object::notification',
  NotificationCommand: 'icinga2::object::notificationcommand',
  ScheduledDowntime: 'icinga2::object::scheduleddowntime',
  Service: 'icinga2::object::service',
  ServiceGroup: 'icinga2::object::servicegroup',
  TimePeriod: 'icinga2::object::timeperiod',
  User: 'icinga2::object::user',
  UserGroup: 'icinga2::object::usergroup',
  Zone: 'icinga2::object::zone',
}

on_icinga_objects.each do |otype, rtype|
  describe(rtype, type: :define) do
    let(:title) do
      'foo'
    end

    let(:pre_condition) do
      [
        "class { 'icinga2': }",
      ]
    end

    let(:facts) do
      facts
    end

    context 'with all defaults' do
      let(:params) do
        {
          target: '/bar/baz',
        }
      end

      it { is_expected.to contain_icinga2__object("icinga2::object::#{otype}::foo").with_object_type(otype) }

      it { is_expected.to compile }
    end
  end
end
