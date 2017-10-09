#
# Cookbook Name:: dmz
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

template '/etc/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
        :spacewalkproxy => node['str_spaceproxy'],
	:smtp => node['str_smtp'],
	:hostname => node['hostname'],
	:fqdn => node['fqdn'],
	:ipaddress => node['ipaddress'],
	:chefserver => node['str_chefserver']
    })
end

execute 'Register to spacewalk proxy' do
  command "cd /root; wget --no-check-certificate https://#{node['spacewalkproxy']}/pub/bootstrap/bootstrap_aac.sh; chmod u+x /root/bootstrap_aac.sh; /root/bootstrap_aac.sh -d DMZ -c #{node['country']}"
  not_if { File.exist?('/root/bootstrap_aac.sh')}
end

directory '/etc/yum.repos.d/bak' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'move *.repo to bak' do
  command "mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak"
  not_if {Dir.glob('/etc/yum.repos.d/*.repo').empty?}
end


execute 'yum update' do
  command "yum -y update"
end

include_recipe 'firewalld'

firewalld_interface 'ens160' do
  action :add
  zone 'dmz'
end

firewalld_port '443/tcp' do
  action :add
  zone 'dmz'
end

firewalld_rich_rule "nag-umb 123" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['nag-umb_ip']}/32"
   port_number '123'
   port_protocol 'udp'
   firewall_action 'accept'
   action :add
end

firewalld_rich_rule "spacewalkproxy_ip 5269" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['spacewalkproxy_ip']}/32"
   port_number '5269'
   port_protocol 'tcp'
   firewall_action 'accept'
   action :add
end

firewalld_rich_rule "spacewalkproxy_ip 5269" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['spacewalkproxy_ip']}/32"
   port_number '5222'
   port_protocol 'tcp'
   firewall_action 'accept'
   action :add
end

firewalld_rich_rule "nag-umb 5666" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['nag-umb_ip']}/32"
   port_number '5666'
   port_protocol 'tcp'
   firewall_action 'accept'
   action :add
end

firewalld_rich_rule "nag-local 5666" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['nagios_local_ip']}/32"
   port_number '5666'
   port_protocol 'tcp'
   firewall_action 'accept'
   action :add
end   

firewalld_rich_rule "nag-local 123" do
   zone 'dmz'
   family 'ipv4'
   source_address "#{node['nagios_local_ip']}/32"
   port_number '123'
   port_protocol 'udp'
   firewall_action 'accept'
   action :add
end   

firewalld_rich_rule "allow all internal IP" do
   zone 'dmz'
   family 'ipv4'
   source_address "10.250.0.0/12"
   firewall_action 'accept'
   action :add
end   


execute 'set default FW zone' do
  command "firewall-cmd --reload; firewall-cmd --set-default-zone=dmz"
end


service 'firewalld' do
  action [:enable, :start]
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
    :mydomain => node['main_cf_mydomain'],
	:relayhost => node['main_cf_relayhost']
    })
end

service 'postfix' do
  action [:enable, :start]
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'sshd' do
  action [:enable, :start]
end

include_recipe 'selinux::enforcing'

execute 'setenforce 1' do
  command "/sbin/setenforce 1"
end


bash 'restorecon' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  restorecon -R /etc/nagios
  setsebool -P ssh_chroot_rw_homedirs on
  restorecon -R /home
  EOH
end

bash 'restorecon' do
  user 'root'
  cwd '/etc/pki/rpm-gpg'
  code <<-EOH
  wget --no-check-certificate https://#{node['spacewalkproxy']}/pub/RPM-GPG-KEY-atomicorp
  EOH
  not_if {File.exist?('/etc/pki/rpm-gpg/RPM-GPG-KEY-atomicorp')}
end

package ['ossec-hids-client'] do
  action :install
end
   
