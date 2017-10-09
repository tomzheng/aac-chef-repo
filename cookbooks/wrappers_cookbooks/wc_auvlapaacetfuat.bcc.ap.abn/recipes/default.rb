#
# Cookbook Name:: wc_auvlapaacetfuat.bcc.ap.abn
# Recipe:: override
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.override['Country'] = 'AU'
node.override['Domain'] = 'BCC'
node.override['Use'] = 'CLR'
node.override['State'] = 'UAT'
node.override['alias'] = 'helios-uat'

