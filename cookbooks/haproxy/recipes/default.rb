#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

execute 'start_haproxy' do
  command "/usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid&"
  not_if 'ps aux | grep haproxy|grep -v color'
end


execute 'restart_haproxy' do
  command "bash -c 'pkill haproxy && /usr/sbin/haproxy-systemd-wrapper -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid&'"
end

templat '/etc/haproxy/haproxy.cfg' do
  source "haproxy.cfg.#{node['hostname']}.erb"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[restart_haproxy]', :immediately
end


