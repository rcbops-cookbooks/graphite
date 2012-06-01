#
# Cookbook Name:: graphite
# Recipe:: carbon
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

# This recipe installs whisper and carbon-cache
#

include_recipe "graphite::common"
include_recipe "graphite::whisper"

package "python-carbon" do
  action :upgrade
end

# TODO: we should tune retention here, based on attributes.
# for now, we'll just drop a simple schema for 1m
# updates and retention of 1d.
template "/etc/carbon/storage-schemas.conf" do
  source "storage-schemas.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "carbon-cache" do
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:template => "/etc/carbon/storage-schemas.conf"), :delayed
end

