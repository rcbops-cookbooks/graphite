require 'chefspec'

platforms = [
  {
    'platform' => 'ubuntu',
    'pkg' => 'statsd-c',
    'service' => 'statsd',
    'confpath' => '/etc/default/statsd'
  },
  {
    'platform' => 'centos',
    'pkg' => 'statsd-c',
    'service' => 'statsd-c',
    'confpath' => '/etc/statsd-c/config'
  }
]

platforms.each do |pltfrm|
  describe 'graphite::statsd' do
    let (:chef_run) {
      runner = ChefSpec::ChefRunner.new() do |node|
        node.automatic_attrs['platform'] = pltfrm['platform']
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
      end
      runner.converge described_recipe
      return runner
    }

    it "should, on #{pltfrm['platform']}, install #{pltfrm['pkg']}" do
      expect(chef_run).to install_package pltfrm['pkg']
    end

    it "should, on #{pltfrm['platform']}, start #{pltfrm['service']}" do
      expect(chef_run).to start_service pltfrm['service']
    end

    it "should, on #{pltfrm['platform']}, enable #{pltfrm['service']}" do
      expect(chef_run).to set_service_to_start_on_boot pltfrm['service']
    end

    it "should, on #{pltfrm['platform']}, create file #{pltfrm['confpath']}"\
      " with correct ownership and permissions" do
        expect(chef_run).to create_file pltfrm['confpath']
        file = chef_run.template(pltfrm['confpath'])
        expect(file).to be_owned_by('root', 'root')
        expect(file.mode).to eq('0644')
    end
  end
end
