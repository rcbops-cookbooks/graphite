require "chef/mixin/shell_out"
module GraphiteTestHelpers
  include Chef::Mixin::ShellOut

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
end
