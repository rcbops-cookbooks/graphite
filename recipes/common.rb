#
# Cookbook Name:: graphite
# Recipe:: common
#
# Copyright 2012, Rackspace US, Inc.
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

# Common config for graphite modules (apt, mostly)

case node["platform"]
  when "ubuntu","debian"
    include_recipe "apt"

    apt_repository "osops" do
      uri "http://ppa.launchpad.net/osops-packaging/ppa/ubuntu"
      distribution node["lsb"]["codename"]
      components ["main"]
      keyserver "keyserver.ubuntu.com"
      key "53E8EA35"
      notifies :run, resources(:execute => "apt-get update"), :immediately
    end
  when "fedora"
    include_recipe "yum"

    yum_key "RPM-GPG-RCB" do
      url "http://build.monkeypuppetlabs.com/repo/RPM-GPG-RCB.key"
      action :add
    end

    yum_repository "rcbops" do
      name "rcb"
      description "RCB-OPS rpm repository"
      url "http://build.monkeypuppetlabs.com/repo/Fedora/$releasever/$basearch"
      key "RPM-GPG-RCB"
      action :add
    end
end


