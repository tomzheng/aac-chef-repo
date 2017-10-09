node.default['edb']['edb_version'] = '9.6'

case node['edb']['edb_version']
when '9.6'
  node.default['edb']['package'] = 'edb-as96'
  node.default['edb']['bin'] = '/usr/edb/as9.6/bin'
  node.default['edb']['sysconfig'] = '/etc/sysconfig/edb/as9.6/edb-as-9.6.sysconfig'
  node.default['edb']['sysconfig_file'] = 'edb-as-9.6.sysconfig'
  node.default['edb']['service'] = 'edb-as-9.6'
  node.default['edb']['home'] = '/var/lib/edb'
  
when '9.4'
  node.default['edb']['package'] = 'ppas94'
  node.default['edb']['bin'] = '/usr/ppas-9.4/bin/'
  node.default['edb']['sysconfig'] = '/etc/sysconfig/ppas/ppas-9.4'
  node.default['edb']['sysconfig_file'] = 'ppas-9.4'
  node.default['edb']['service'] = 'ppas-9.4'
  node.default['edb']['home'] = '/var/lib/ppas'
end

