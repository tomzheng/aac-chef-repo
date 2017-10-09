#
# Cookbook Name:: bartpem
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.


template '/opt/PostgresPlus/9.4AS/data/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode '0600'
  notifies :run, 'execute[reloaddb]', :immediately
end


execute 'reloaddb' do
  user 'postgres'
  command '/opt/PostgresPlus/9.4AS/bin/pg_ctl -D /opt/PostgresPlus/9.4AS/data/ reload'
end

template '/usr/edb-bart-1.1/etc/bart.cfg' do
  source 'bart.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/usr/edb-bart-1.1/etc/bart_edb-as96.cfg' do
  source 'bart_edb-as96.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/home/bart/.ssh/authorized_keys2' do
  source 'authorized_keys2.erb'
  owner 'bart'
  group 'bart'
  mode '0600'
end

template '/home/bart/PROD_BART_BACKUP.sh' do
  source 'PROD_BART_BACKUP.sh.erb'
  owner 'bart'
  group 'bart'
  mode '0700'
end

template '/home/bart/.pgpass' do
  source 'pgpass.erb'
  owner 'bart'
  group 'bart'
  mode '0600'
end


template '/home/bart/UAT_BART_BACKUP.sh' do
  source 'UAT_BART_BACKUP.sh.erb'
  owner 'bart'
  group 'bart'
  mode '0700'
end

