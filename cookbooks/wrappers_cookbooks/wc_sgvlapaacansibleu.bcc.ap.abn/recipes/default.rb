#
# Cookbook Name:: wc_sgvlapaacansibleu.bcc.ap.abn
# Recipe:: override
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.override['Country'] = 'SG'
node.override['Domain'] = 'BCC'
node.override['Use'] = 'CLR'
node.override['State'] = 'PROD'

include_recipe "aac_linux_baseline"

