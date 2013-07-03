require 'chefspec'

describe 'graphite::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'graphite::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
