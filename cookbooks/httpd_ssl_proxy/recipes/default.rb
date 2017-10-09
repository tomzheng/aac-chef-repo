#
# Cookbook Name:: httpd_ssl_proxy
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

include_recipe "httpd_ssl_proxy::httpd"
include_recipe "httpd_ssl_proxy::ssl"
include_recipe "httpd_ssl_proxy::proxy"
