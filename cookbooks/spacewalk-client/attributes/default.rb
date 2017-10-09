default['spacewalk']['pkg_source_path'] = Chef::Config[:file_cache_path]
default['spacewalk']['rhel']['base_url'] = 'http://yum.spacewalkproject.org/2.4-client/RHEL'
default['spacewalk']['rhel']['repo_version'] = '2.4'
default['spacewalk']['enable_osad'] = false
default['spacewalk']['enable_rhncfg'] = false
default['spacewalk']['reg']['key'] = '1-prod'
default['spacewalk']['reg']['server'] = 'http://spacewalk.bcc.ap.abn/XMLRPC'
default['spacewalk']['rhncfg']['actions']['run'] = false
