require_relative './support/helpers'

test_platforms = {
  'ubuntu' => {
    :packages => 'python-whisper'
  },
  'centos' => {
    :packages => 'whisper'
  }
}

describe_recipe 'graphite::whisper' do
  include GraphiteTestHelpers

  it 'should install packages listed in attributes' do
    pkg = test_platforms[node['platform']][:packages]
    package(pkg).must_be_installed
  end
end
