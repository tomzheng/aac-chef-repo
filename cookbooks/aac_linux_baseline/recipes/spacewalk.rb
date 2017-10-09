#These are node attribute, set by on node level, uncomment when test kitchen
#
node.default['Country'] = 'SG'
node.default['Domain'] = 'BCC'
node.default['Use'] = 'CLR'
node.default['State'] = 'UAT'

databag = data_bag_item('apac','spacewalk')
if node['platform_family'] == "rhel" && node['platform_version'].include?("6.")
  node.default['spacewalk']['spacewalkrepo'] = databag['centos6_spacewalkrepo']
  node.default['spacewalk']['epelrepo'] = databag['centos6_epelrepo']
else
  node.default['spacewalk']['spacewalkrepo'] = databag['centos7_spacewalkrepo']
  node.default['spacewalk']['epelrepo'] = databag['centos7_epelrepo']
end

execute 'echo spacewalk' do
  command "echo #{node['spacewalk']['spacewalkrepo']},  #{node['Country']},#{node['State']}, #{node['Use']} > /tmp/spacewalk.out"
end


bash 'install epel packages' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  export http_proxy=http://proxy.sg.fap:3128; export https_proxy=$http_proxy;
  rpm -Uvh node['spacewalk']['spacewalkrepo']
  rpm -Uvh node['spacewalk']['epelrepo']
  yum -y install wget rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin rhncfg rhncfg-actions rhncfg-client spacewalk-oscap --skip-broken
  unset http_proxy https_proxy;
  EOH
end


bash 'Register to spacewalk' do
  user 'root'
  cwd '/root'
  code <<-EOH
  unset http_proxy https_proxy;
  cd /root; wget --no-check-certificate https://spacewalk.bcc.ap.abn/pub/bootstrap/bootstrap_aac.sh; chmod u+x /root/bootstrap_aac.sh; /root/bootstrap_aac.sh -d "#{node['Domain']}" -c "#{node['Country']}" -s "#{node['State']}" -u "#{node['Use']}"
  touch /root/spacewalk_success
  EOH
  not_if {File.exist?('/root/spacewalk_success')}
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
  command "yum -y update --nogpgcheck"
end

execute 'move *.repo to bak' do
  command "mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak"
  not_if {Dir.glob('/etc/yum.repos.d/*.repo').empty?}
end

