
package 'mod_ssl' do
  action :install
end

directory '/etc/httpd/certs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "/etc/httpd/certs/#{node['hostname']}.cer" do
  source "#{node['hostname']}.cer.erb"
  owner 'root'
  group 'root'
  mode '0644'
end

template "/etc/httpd/certs/#{node['hostname']}.pem" do
  source "#{node['hostname']}.pem.erb"
  owner 'root'
  group 'root'
  mode '0644'
end

template "/etc/httpd/certs/#{node['hostname']}.p7b" do
  source "#{node['hostname']}.p7b.erb"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[httpd]', :immediately
end



