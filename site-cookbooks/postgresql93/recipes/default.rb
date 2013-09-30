#
# Cookbook Name:: postgresql93
# Recipe:: default
#
# Copyright 2013, Uptime Technologies, LLC.
#
# All rights reserved - Do Not Redistribute
#
template "resolv.conf" do
  path "/etc/resolv.conf"
  source "resolv.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "iptables" do
  path "/etc/sysconfig/iptables"
  source "iptables.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
end

service "iptables" do
  supports :status => true , :restart => true , :reload => false
  action [ :enable, :restart ]
end

cookbook_file "/tmp/pgdg-redhat93-9.3-1.noarch.rpm" do
  mode 00644
  checksum "52697bf42907b503faeaea199959bc711a493f4ed67d5f4c9ecf8a9066611c49"
end

package "pgdg-redhat93" do
action :install
  source "/tmp/pgdg-redhat93-9.3-1.noarch.rpm"
end

%w{postgresql93 postgresql93-contrib postgresql93-libs postgresql93-server postgresql93-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

