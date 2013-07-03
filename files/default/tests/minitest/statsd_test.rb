require_relative './support/helpers'

test_platforms = {
  'ubuntu' => {
    :package => 'statsd-c',
    :service => 'statsd',
    :conf => '/etc/default/statsd'
  },
  'centos' => {
    :package => 'statsd-c',
    :service => 'statsd-c',
    :conf => '/etc/statsd-c/config'
  }
}

describe_recipe 'graphite::statsd' do
  include GraphiteTestHelpers

  it 'should install statsd' do
    pkg = test_platforms[node['platform']][:package]
    package(pkg).must_be_installed
  end

  it 'should start statsd' do
    svc = test_platforms[node['platform']][:service]
    service(svc).must_be_running
  end

  it 'should enable statsd' do
    svc = test_platforms[node['platform']][:service]
    service(svc).must_be_enabled
  end

  it 'should ensure the config file has '\
    'the correct ownership and permissions' do
      conf_file = test_platforms[node['platform']][:conf]
      file(conf_file).must_exist.with(:owner, 'root').and(:group, 'root').and(
        :mode, '0644')
  end
end
