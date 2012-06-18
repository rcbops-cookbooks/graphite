#
# Cookbook Name:: graphite
# Recipe:: statsd
#
# Copyright 2012, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This recipe installs the statsd server
#


# Hey Joe, this isn't going to work on teh fedoras.  Can fix?  :p
package "statsd-c" do
  action :install
end

service "statsd" do
  supports :status => true, :restart => true
  action [ :start, :enable ]
end

carbon_endpoint = get_bind_endpoint("carbon","line-receiver")

template "/etc/default/statsd" do
  source "statsd-default.erb"
  owner "root"
  group "root"
  mode "0644"
  variables("carbon_host" => carbon_endpoint["host"],
            "carbon_port" => carbon_endpoint["port"],
            "flush_interval" => node["statsd"]["flush_interval"]
            )

  notifies :restart, resources(:service => "statsd"), :immediately
end