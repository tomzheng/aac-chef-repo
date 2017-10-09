#
# Cookbook Name:: aac_linux_baseline
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

include_recipe "aac_linux_baseline::spacewalk"
include_recipe "aac_linux_baseline::join_ad"
