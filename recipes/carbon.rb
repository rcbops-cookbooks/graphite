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

platform_options = node["graphite"]["platform"]

platform_options["carbon_packages"].each do |pkg|
  package pkg do
    action :upgrade
    options platform_options["package_overrides"]
  end
end

# TODO: we should tune retention here, based on attributes.
# for now, we'll just drop a simple schema for 1m
# updates and retention of 1d.

template platform_options["carbon_schema_config"] do
  source "storage-schemas.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template platform_options["carbon_config_dest"] do
  source platform_options["carbon_config_source"]
  owner "root"
  group "root"
  mode "0644"
  only_if { platform?(%w{fedora}) }
end

service "carbon-cache" do
  service_name platform_options["carbon_service"]
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources(:template => platform_options["carbon_config"]), :delayed
end

