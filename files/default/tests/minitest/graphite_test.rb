require_relative './support/helpers'

#include GraphiteTestHelpers

test_platforms = {
  'ubuntu' => {
    :packages => ["python-cairo", "graphite"],
    :conf_file => '/etc/apache2/ports.conf'
  },
  'centos' => {
    :packages => ["bitmap", "bitmap-fonts-compat", "pycairo", "Django14",
      "python-django-tagging", "graphite-web", "mod_python"],
    :conf_file => '/etc/httpd/ports.conf'
  }
}
describe_recipe 'graphite::graphite' do
  include GraphiteTestHelpers
  it 'should install packages' do
    test_platforms[node['platform']][:packages].each do |pkg|
      package(pkg).must_be_installed
    end
  end

  it 'should create the ports.conf file' do
    filename = test_platforms[node['platform']][:conf_file]
    file(filename).must_exist.with(:mode, '0644')
  end
end
