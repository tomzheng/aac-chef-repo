directory '/etc/httpd/certs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


template '/etc/httpd/certs/sslkey.cnf' do
  source 'sslkey.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
        :hostname => node['hostname'],
	:alias => node['alias']
    })
end


execute 'Generate SSL request key' do
  cwd '/etc/httpd/certs'
  command "openssl req -new -newkey rsa:2048 -nodes -keyout #{node['hostname']}.pem -out #{node['hostname']}.req -subj '/C=/ST=/L=/O=/OU=/CN=#{node['hostname']}.bcc.ap.abn/emailAddress=it@au.abnamroclearing.com' -config sslkey.cnf"
  not_if { File.exist?("/etc/httpd/certs/#{node['hostname']}.pem")}
end

