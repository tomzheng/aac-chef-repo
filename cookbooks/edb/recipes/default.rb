#
# Cookbook Name:: edb
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
user 'enterprisedb' do
  action :create
  home "#{node['edb']['home']}"
  manage_home true
  shell '/bin/bash'
  not_if { File.directory?("#{node['edb']['home']}")}
end

template "/etc/pki/rpm-gpg/ENTERPRISEDB-GPG-KEY" do
  source 'ENTERPRISEDB-GPG-KEY.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

package node['edb']['package'] do
  action :install
end

template "/usr/lib/systemd/system/edb-as-9.6.service" do
  source 'edb-as-9.6.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  only_if { node['edb']['edb_version'] == '9.6' && node['platform_family'].include?("rhel") && node['platform_version'].include?("7.") }
end

execute "systemctl daemon-reload" do
  user 'root'
  command "systemctl daemon-reload"
  only_if { node['edb']['edb_version'] == '9.6' && node['platform_family'].include?("rhel") && node['platform_version'].include?("7.") }
end


execute "mkdir -p /opt/PostgresPlus/#{node['edb']['edb_version']}AS/data" do
  user 'root'
  cwd '/tmp'
  command "mkdir -p /opt/PostgresPlus/#{node['edb']['edb_version']}AS/data && chown -R enterprisedb:enterprisedb /opt/PostgresPlus"
  not_if { File.exist?("/opt/PostgresPlus/#{node['edb']['edb_version']}AS/data/pg_hba.conf")}
end


template node['edb']['sysconfig'] do
  source "#{node['edb']['sysconfig_file']}.erb"
  owner 'root'
  group 'root'
  mode '0755'
  notifies :run, 'execute[initdb]', :immediately
end
  
execute 'initdb' do
  user 'enterprisedb'
  command "chown -R enterprisedb:enterprisedb /opt/PostgresPlus && #{node['edb']['bin']}/initdb -D /opt/PostgresPlus/#{node['edb']['edb_version']}AS/data"
  notifies :restart, "service[#{node['edb']['service']}]"
  not_if { File.exist?("/opt/PostgresPlus/#{node['edb']['edb_version']}AS/data/pg_hba.conf")}
end
  


template "/opt/PostgresPlus/#{node['edb']['edb_version']}AS/data/pg_hba.conf" do
  source 'pg_hba.conf.erb'
  owner 'enterprisedb'
  group 'enterprisedb'
  mode '0600'
end

template "/opt/PostgresPlus/#{node['edb']['edb_version']}AS/data/postgresql.conf" do
  source 'postgresql.conf.erb'
  owner 'enterprisedb'
  group 'enterprisedb'
  mode '0600'
end


directory "/opt/PostgresPlus/#{node['edb']['edb_version']}AS/data/pg_log" do
  owner 'enterprisedb'
  group 'enterprisedb'
  action :create
end


service node['edb']['service'] do
  action [:enable, :start]
end

package 'pem-agent' do
  action :install
end

execute 'register pem-agent' do
  user 'root'
  cwd '/tmp'
  command 'cd /usr/pem/agent/bin && PGPASSWORD=postgres ./pemworker --register-agent --pem-server SGVLGSAACbarpem --pem-port 5432 --pem-user postgres'
  not_if { File.exist?('/usr/pem/agent/etc/agent.cfg')}
end
 
file_replace "/usr/pem/agent/etc/agent.cfg" do
	replace "heartbeat_connection=false"
	with    "heartbeat_connection=true"
end


service 'pemagent' do
  action [:enable, :start]
end

execute "create-bartbackup-user" do
    user 'enterprisedb'
    code = <<-EOH
    psql -d postgres -c "select * from pg_user where usename='bartbackup'" | grep -c bartbackup
    EOH
    command 'psql -d postgres -c "CREATE ROLE bartbackup WITH LOGIN SUPERUSER PASSWORD \'bartbackup\';"'
    not_if code 
end

execute 'ssh-keygen' do
  user 'enterprisedb'
  command "ssh-keygen -t rsa -q -N \"\" -f #{node['edb']['home']}/.ssh/id_rsa"
  not_if { File.exist?("#{node['edb']['home']}/.ssh/id_rsa")}
end


 template "#{node['edb']['home']}/.ssh/authorized_keys" do
  source 'authorized_keys.erb'
  owner 'enterprisedb'
  group 'enterprisedb'
  mode '0600'
 end
