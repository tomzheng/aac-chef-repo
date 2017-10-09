#
# Cookbook Name:: wc_HKVLAPAACfixco.bcc.ap.abn
# Recipe:: override
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.override['Country'] = 'HK'
node.override['Domain'] = 'BCC'
node.override['Use'] = 'GES'
node.override['State'] = 'PROD'

include_recipe "aac_linux_baseline"

