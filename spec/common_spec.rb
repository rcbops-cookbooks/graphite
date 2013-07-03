require 'chefspec'

describe 'graphite::common' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'graphite::common' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
