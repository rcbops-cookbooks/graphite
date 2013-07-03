require 'chefspec'

['ubuntu', 'centos'].each do |platform|
  describe 'graphite::carbon' do
    let (:chef_run) {
      runner = ChefSpec::ChefRunner.new() do |node|
        node.automatic_attrs['platform'] = platform
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

    recipes = ["graphite::common", "graphite::whisper"]
    recipes.each do |rcp|
      it "should include recipe #{rcp}" do
        expect(chef_run).to include_recipe rcp
      end
    end

    it "should install #{platform} packages specified in carbon_packages" do
      chef_run.converge described_recipe
      chef_run.node['graphite']['platform']['carbon_packages'].each do |pkg|
        expect(chef_run).to install_package pkg
      end
    end

    filenames = {
      'ubuntu' => '/etc/carbon/storage-schemas.conf',
      'centos' => '/opt/graphite/conf/storage-schemas.conf'
    }
    filename = filenames[platform]
    it "should, on #{platform}, create file #{filename}"\
      " with correct ownership and permissions" do
        expect(chef_run).to create_file filename
        file = chef_run.template(filename)
        expect(file).to be_owned_by('root', 'root')
        expect(file.mode).to eq('0644')
    end

    filenames = {
      'ubuntu' => '/etc/carbon/carbon.conf',
      'centos' => '/opt/graphite/conf/carbon.conf'
    }
    it "should on #{platform}, create file #{filename}"\
      " with correct ownership and permissions" do
        expect(chef_run).to create_file filename
        file = chef_run.template(filename)
        expect(file).to be_owned_by('root', 'root')
        expect(file.mode).to eq('0644')
    end

    srvc = 'carbon-cache'

    it "should, on #{platform}, enable #{srvc}" do
      expect(chef_run).to set_service_to_start_on_boot srvc
    end

    it "should, on #{platform}, restart #{srvc}" do
      expect(chef_run).to restart_service srvc
    end
  end
end
