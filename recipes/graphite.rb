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

#
# Workaround to install apache2 on a fedora machine with selinux set to enforcing
# TODO(breu): this should move to a subscription of the template from the apache2 recipe
#             and it should simply be a restorecon on the configuration file(s) and not
#             change the selinux mode
#

execute "graphite-set-selinux-permissive" do
  command "/sbin/setenforce Permissive"
  action :run
  only_if "[ ! -e /etc/httpd/conf/httpd.conf ] && [ -e /etc/redhat-release ] && [ $(/sbin/sestatus | grep -c '^Current mode:.*enforcing') -eq 1 ]"
end

include_recipe "graphite::common"
include_recipe "graphite::statsd"
include_recipe "apache2"

# TODO: OMG this needs to be fixed.
execute "graphite-restore-selinux-context" do
    command "restorecon -Rv /etc/httpd"
    action :run
    only_if do platform?("fedora") end
end

include_recipe "apache2::mod_status"

# TODO: OMG this needs to be fixed.
execute "graphite-restore-selinux-context" do
    command "restorecon -Rv /etc/httpd"
    action :run
    only_if do platform?("fedora") end
end


# Workaround to re-enable selinux after installing apache on a fedora machine that has
# selinux enabled and is currently permissive and the configuration set to enforcing.
# TODO(breu): get the other one working and this won't be necessary
#
execute "graphite-set-selinux-enforcing" do
  command "/sbin/setenforce Enforcing ; restorecon -R /etc/httpd"
  action :run
  only_if "[ -e /etc/httpd/conf/httpd.conf ] && [ -e /etc/redhat-release ] && [ $(/sbin/sestatus | grep -c '^Current mode:.*permissive') -eq 1 ] && [ $(/sbin/sestatus | grep -c '^Mode from config file:.*enforcing') -eq 1 ]"
end

platform_options = node["graphite"]["platform"]

platform_options["graphite_packages"].each do |pkg|
  package pkg do
    action :upgrade
    options platform_options["package_overrides"]
  end
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

execute "graphite-restore-selinux-context" do
    command "restorecon -Rv /etc/httpd"
    action :run
    only_if do platform?("fedora") end
end

web_app "graphite" do
  server_name node["hostname"]
  server_aliases [ node["fqdn"] ]
  template "graphite_app.erb"
end
