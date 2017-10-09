#
# Cookbook Name:: helloworld
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

file '/tmp/motd' do
  content 'hello world'
end

