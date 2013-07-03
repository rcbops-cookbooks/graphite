require 'chefspec'

describe 'graphite::graphite' do
  it 'should use port 8080 if on the same server as horizon' do
    chef_run = ChefSpec::ChefRunner.new() do |node|
      Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
        {
          'host' => '1.2.3.4',
          'port' => '80'
        }
      )
      node.automatic_attrs['platform'] = 'ubuntu'
      Chef::Config[:role_path] = './spec/roles'
    end
    chef_run.converge("role[horizon-server]", "recipe[graphite::graphite]")
    expect(chef_run.node["apache"]["listen_ports"]).to include('8080')
    expect(chef_run.node["graphite"]["services"]["api"]["port"]).to eq(8080)
  end

  rcps = [
    'graphite::common',
    'graphite::statsd',
    'apache2',
    'apache2::mod_status'
  ]
  rcps.each do |recipe|
    it "should include the recipe #{recipe}" do
      chef_run = ChefSpec::ChefRunner.new() do |node|
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
        node.automatic_attrs['platform'] = 'ubuntu'
      end
      chef_run.converge described_recipe
      expect(chef_run).to include_recipe recipe
    end
  end

  it 'should create a ports.conf file' do
    chef_run = ChefSpec::ChefRunner.new() do |node|
      Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
        {
          'host' => '1.2.3.4',
          'port' => '80'
        }
      )
      node.automatic_attrs['platform'] = 'ubuntu'
    end
  end
  ['ubuntu', 'centos'].each do |platform|
    it "should, on #{platform}, install the packages defined in attributes." do
      chef_run = ChefSpec::ChefRunner.new() do |node|
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
        node.automatic_attrs['platform'] = platform
      end
      chef_run.converge described_recipe
      chef_run.node['graphite']['platform']['graphite_packages'].each do |pkg|
        expect(chef_run).to install_package pkg
      end
    end
    it "should, on #{platform}, create ports.conf with correct permissions" do
      chef_run = ChefSpec::ChefRunner.new() do |node|
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
        node.automatic_attrs['platform'] = platform
      end
      chef_run.converge described_recipe
      filepath = "#{chef_run.node['apache']['dir']}/ports.conf"
      expect(chef_run).to create_file filepath
      file = chef_run.template(filepath)
      expect(file.mode).to eq(0644)
    end

    it "should, on #{platform}, restart apache" do
      chef_run = ChefSpec::ChefRunner.new() do |node|
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
        node.automatic_attrs['platform'] = 'ubuntu'
      end
      chef_run.converge described_recipe
      template_name = "#{chef_run.node['apache']['dir']}/ports.conf"
      ports_template = chef_run.template(template_name)
      expect(ports_template).to notify 'service[apache2]', :restart
    end
  end

  ['default-ssl', 'default'].each do |site|
    it "should disable apache site #{site}" do
      apache_dir = '/etc/apache2'
      chef_run = ChefSpec::ChefRunner.new(
        :step_into => ['apache_site'], :evaluate_guards => true) do |node|
          Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
            {
              'host' => '1.2.3.4',
              'port' => '80'
            }
          )
          node.automatic_attrs['platform'] = 'ubuntu'
          File.stub(:symlink?).and_call_original
          site_file = "#{apache_dir}/sites-enabled/#{site}"
          File.stub(:symlink?).with(site_file).and_return(true)
          site000_file = "#{apache_dir}/sites-enabled/000-#{site}"
          File.stub(:symlink?).with(site000_file).and_return(true)
        end
      chef_run.converge described_recipe
      expect(chef_run).to execute_command("/usr/sbin/a2dissite #{site}")
    end
  end

  ['centos', 'redhat', 'fedora'].each do |platform|
    it "should set selinux to permissive for #{platform}" do
      chef_run = ChefSpec::ChefRunner.new(
        { :evaluate_guards => true }) do |node|
          Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
            {
              'host' => '1.2.3.4',
              'port' => '80'
            }
          )
          node.automatic_attrs['platform'] = platform
        end
      chef_run.converge described_recipe
      expect(chef_run).to execute_command "restorecon -Rv /etc/httpd"
    end
  end
end
