require 'chefspec'

describe 'graphite::whisper' do
  ['ubuntu', 'centos'].each do |platform|
    it "should install #{platform} packages specified in whister_packages" do
      chef_run = ChefSpec::ChefRunner.new do |node|
        node.automatic_attrs['platform'] = platform
      end
      chef_run.converge described_recipe
      chef_run.node['graphite']['platform']['whisper_packages'].each do |pkg|
        expect(chef_run).to install_package pkg
      end
    end
  end
end
