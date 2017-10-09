
template "/etc/httpd/conf.d/proxy.conf" do
  source 'proxy.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
        :hostname => node['hostname']
    })
  notifies :restart, 'service[httpd]', :immediately
end

