#
# Cookbook Name:: wc_sgvlapaacmanageiq.bcc.ap.abn
# Recipe:: override
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.override['Country'] = 'SG'
node.override['Domain'] = 'BCC'
node.override['Use'] = 'CLR'
node.override['State'] = 'UAT'
node.override['alias'] = ''

