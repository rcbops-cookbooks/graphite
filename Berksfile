# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

site :opscode

metadata

group :test do
  cookbook "apt",         :git => "https://github.com/opscode-cookbooks/apt.git"
  cookbook "osops-utils", :git => "https://github.com/rcbops-cookbooks/osops-utils.git", :branch => "grizzly"
  cookbook "sysctl",      :git => "https://github.com/rcbops-cookbooks/sysctl.git", :branch => "grizzly"
  cookbook "yum",         :git => "https://github.com/opscode-cookbooks/yum.git"

  # use specific version until minitest file discovery is fixed
  cookbook "minitest-handler", "0.1.7"
end
