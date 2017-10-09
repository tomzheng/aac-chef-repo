template "/etc/pki/rpm-gpg/#{node['mendix']['epelkey']}" do
  source "#{node['mendix']['epelkey']}.erb"
  owner 'root'
  group 'root'
  mode '0644'
end

package 'm2ee-tools' do
  action :install
end

group 'mxapp' do
  action :create
  members 'mxapp'
  append true
end


%w[ /opt/mxapp /opt/mxapp/runtime /opt/mxapp/web ].each do |path|
  directory path do
    owner 'mxapp'
    group 'mxapp'
    action :create
  end
end

%w[ /opt/mxapp/model /opt/mxapp/data /opt/mxapp/data/database /opt/mxapp/data/files /opt/mxapp/data/model-upload /opt/mxapp/data/tmp ].each do |path|
  directory path do
    owner 'mxapp'
    group 'mxapp'
    mode '0700'
    action :create
  end
end

template "#{node['mendix']['homedir']}/.m2ee/m2ee.yaml" do
  source 'm2ee.yaml.erb'
  owner 'mxapp'
  group 'mxapp'
  mode '0644'
  not_if { File.exist?("#{node['mendix']['homedir']}/.m2ee/m2ee.yaml") }
end

bash 'extract runtime package' do
  user 'mxapp'
  cwd '/opt/mxapp/runtimes'
  code <<-EOH
  wget --no-check-certificate https://spacewalk.bcc.ap.abn/pub/mendix-4.1.0.tar.gz
  tar xzvf /opt/mxapp/runtimes/mendix-4.1.0.tar.gz -C /opt/mxapp/runtimes
  EOH
end



