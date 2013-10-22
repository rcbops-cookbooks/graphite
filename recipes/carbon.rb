#
# Cookbook Name:: graphite
# Recipe:: carbon
#
# Copyright 2012-2013, Rackspace US, Inc.
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

include_recipe "graphite::common"
include_recipe "graphite::whisper"

platform_options = node["graphite"]["platform"]

platform_options["carbon_packages"].each do |pkg|
  package pkg do
    action :install
    options platform_options["package_options"]
  end
end

line_receiver_endpoint = get_bind_endpoint("carbon", "line-receiver")
pickle_receiver_endpoint = get_bind_endpoint("carbon", "pickle-receiver")
cache_query_endpoint = get_bind_endpoint("carbon", "cache-query")

storage_schemas = node["carbon"]["storage_schemas"]

template "#{platform_options["carbon_conf_dir"]}/storage-schemas.conf" do
  source "storage-schemas.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :storage_schemas => storage_schemas
end

template "#{platform_options["carbon_conf_dir"]}/carbon.conf" do
  source "carbon.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables("line_receiver_ip" => line_receiver_endpoint["host"],
    "line_receiver_port" => line_receiver_endpoint["port"],
    "pickle_receiver_ip" => pickle_receiver_endpoint["host"],
    "pickle_receiver_port" => pickle_receiver_endpoint["port"],
    "cache_query_ip" => cache_query_endpoint["host"],
    "cache_query_port" => cache_query_endpoint["port"],
    "apache_user" => platform_options["carbon_apache_user"],
    "carbon_conf_dir" => platform_options["carbon_conf_dir"],
    "carbon_log_dir" => platform_options["carbon_log_dir"],
    "graphite_root" => platform_options["graphite_root"]
  )
end

service "carbon-cache" do
  service_name platform_options["carbon_service"]
  supports :status => true, :restart => true
  action [:enable, :restart]
  storage_tmplt = "template[#{platform_options["carbon_conf_dir"]}/"\
    "storage-schemas.conf]"
  subscribes :restart, storage_tmplt, :delayed
  carbon_tmplt = "template[#{platform_options["carbon_conf_dir"]}/carbon.conf]"
  subscribes :restart, carbon_tmplt, :delayed
end
