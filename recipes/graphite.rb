#
# Cookbook Name:: graphite
# Recipe:: graphite
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

# This recipe installs the graphite web server
#

include_recipe "graphite::common"
include_recipe "apache2"
include_recipe "apache2::mod_status"

package "graphite" do
  action :upgrade
end

# this is kinda ugly
apache_site "default" do
  enable false
end

apache_site "default-ssl" do
  enable false
end

# FIXME: should install memcache server

# FIXME: should fix up local settings to point to carbon cache instances,
# (and memcache servers) but this requires package changes to move local
# settings someplace not stupid

web_app "graphite" do
  server_name node["hostname"]
  server_aliases [ node["fqdn"] ]
  template "graphite_app.erb"
end

