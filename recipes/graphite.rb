#
# Cookbook Name:: graphite
# Recipe:: graphite
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

# This recipe installs the graphite web server

# TODO(shep): Need to compare against horizon ip:port for collision
# for now just set it to 8080 if horizon and graphite are on the same server
if node["roles"].include?("horizon-server")
  node.set["graphite"]["services"]["api"]["port"] = 8080
  if not node["apache"]["listen_ports"].include?("8080")
    ports = node["apache"]["listen_ports"]
    node.set["apache"]["listen_ports"] = ports + ["8080"]
  end
end

#
# Workaround to install apache2 on a fedora machine with selinux set to
# enforcing
# TODO(breu): this should move to a subscription of the template from the
# apache2 recipe and it should simply be a restorecon on the configuration
# file(s) and not change the selinux mode
#

execute "graphite-set-selinux-permissive" do
  command "/sbin/setenforce Permissive"
  action :run
  only_if "[ ! -e /etc/httpd/conf/httpd.conf ] &&"\
    " [ -e /etc/redhat-release ] &&"\
      " [ $(/sbin/sestatus | grep -c '^Current mode:.*enforcing') -eq 1 ]"
end

include_recipe "graphite::common"
include_recipe "graphite::statsd"
include_recipe "apache2"
include_recipe "apache2::mod_status"
# Workaround to re-enable selinux after installing apache on a fedora machine
# that has selinux enabled and is currently permissive and the configuration
# set to enforcing.
# TODO(breu): get the other one working and this won't be necessary
#
execute "graphite-set-selinux-enforcing" do
  command "/sbin/setenforce Enforcing ; restorecon -R /etc/httpd"
  action :run
  only_if "[ -e /etc/httpd/conf/httpd.conf ] &&"\
    " [ -e /etc/redhat-release ] &&"\
      " [ $(/sbin/sestatus | grep -c '^Current mode:.*permissive') -eq 1 ] &&"\
        " [ $(/sbin/sestatus | grep -c '^Mode from config file:.*enforcing')"\
          " -eq 1 ]"
    end

      platform_options = node["graphite"]["platform"]

    platform_options["graphite_packages"].each do |pkg|
      package pkg do
        action :install
        options platform_options["package_options"]
        if pkg == 'graphite-web' and platform?("redhat", "centos", "fedora")
          options '--disablerepo="*" --enablerepo=rcb --enablerepo=rcb-testing'
        end
      end
  end

%W(default default-ssl).each do |name|
  apache_site name do
    enable false
  end
end

# FIXME: should install memcache server
# FIXME: should fix up local settings to point to carbon cache instances,
# (and memcache servers) but this requires package changes to move local
# settings someplace not stupid
graphite_endpoint = get_bind_endpoint("graphite", "api")
web_app "graphite" do
  server_name node["hostname"]
  server_aliases [node["fqdn"]]
  graphite_pythonpath platform_options['graphite_pythonpath']
  graphite_log_dir platform_options['graphite_log_dir']
  template "graphite_app.erb"
  bind_host graphite_endpoint["host"]
  bind_port graphite_endpoint["port"]
end

# This angers Shep because apache:listen_ports is getting stomped somewhere
ports = node["apache"]["listen_ports"].map { |p| p.to_i }.uniq
template "#{node["apache"]["dir"]}/ports.conf" do
  source "ports.conf.erb"
  cookbook "apache2"
  variables :apache_listen_ports => ports
  notifies :restart, "service[apache2]"
  mode 0644
end
