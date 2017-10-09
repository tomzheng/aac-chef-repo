#
# Cookbook Name:: mendix
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

if node['platform_family'] == "rhel" && node['platform_version'].include?("6.")
  node.default['mendix']['epelkey'] = 'RPM-GPG-KEY-EPEL-6'
else 
  node.default['mendix']['epelkey'] = 'RPM-GPG-KEY-EPEL-7'
end

if File.directory?("/home/BCC")
  node.default['mendix']['homedir'] = '/home/BCC/mxapp'
else
  node.default['mendix']['homedir'] = '/home/mxapp'
end

include_recipe "mendix::mendix_install"

