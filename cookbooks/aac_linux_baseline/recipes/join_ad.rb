case node['Country']
when 'AU'
  node.default['join_ad']['ad_loc'] = 'Member Servers/Sydney'
when 'SG'
  node.default['join_ad']['ad_loc'] = 'Member Servers/Singapore'
when 'HK'
  node.default['join_ad']['ad_loc'] = 'Member Servers/Hong Kong'
when 'JP'
  node.default['join_ad']['ad_loc'] = 'Member Servers/Japan'
end

case node['Domain']
when 'BCC'
  node.default['join_ad']['domain_fqdn'] = "#{node['Domain']}.AP.ABN"
when 'APAC'
  node.default['join_ad']['domain_fqdn'] = "#{node['Domain']}.DMA.AAC"
end

databag = data_bag_item('apac','activedirectory')
node.default['join_ad']['adpassword'] = databag['adpassword']
node.default['join_ad']['aduser'] = databag['aduser']

execute 'echo spacewalk' do
  command "echo #{node['spacewalk']['spacewalkrepo']} , #{node['join_ad']['domain_fqdn']} ,#{node['join_ad']['aduser']} , #{node['join_ad']['adpassword']}, #{node['join_ad']['ad_loc']}, #{node['Country']},#{node['State']}, #{node['Use']} > /tmp/join_ad.out"
end




package ['sssd', 'samba-common', 'krb5-workstation', 'oddjob-mkhomedir', 'nfs-utils', 'nfs-utils-lib', 'cifs-utils', 'samba-winbind', 'samba-winbind-clients', 'pam_krb5'] do
  action :install
end

template '/etc/krb5.conf' do
  source 'krb5.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
        :domain => node['join_ad']['domain_fqdn']
    })
end

template '/etc/samba/smb.conf' do
  source 'smb.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
        :domain => node['join_ad']['domain_fqdn']
    })
end

template '/etc/sssd/sssd.conf' do
  source "sssd_#{node['Domain']}.conf.erb"
  owner 'root'
  group 'root'
  mode '0600'
end

bash 'Join_ad' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  kdestroy
  klist
  echo "#{node['join_ad']['adpassword']}"|kinit svc_ladmin
  echo "net ads join -k  createcomputer="#{node['join_ad']['ad_loc']}"" >> /tmp/join_ad.out
  net ads join -k  createcomputer="#{node['join_ad']['ad_loc']}" >> /tmp/join_ad.out 
  authconfig --enablesssd --enablesssdauth --enablemkhomedir --update
  EOH
  flags "-x"
  not_if { File.exist?('/etc/krb5.keytab')}
end

service 'messagebus' do
  action [:restart, :enable]
end

service 'oddjobd' do
  action [:restart, :enable]
end

service 'sssd' do
  action [:restart, :enable]
end




