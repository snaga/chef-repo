#
# Cookbook Name:: postgresql93
# Recipe:: initdb
#
# Copyright 2013, Uptime Technologies, LLC.
#
# All rights reserved - Do Not Redistribute
#
bash "postgresql93-pgbasebackup" do
  not_if { File.exists?("/var/lib/pgsql/9.3/data/PG_VERSION") }
  master_address = node['postgresql93']['master_address']
  code <<-EOC
    sudo -u postgres /usr/pgsql-9.3/bin/pg_basebackup -D /var/lib/pgsql/9.3/data -h #{master_address} -U replication --xlog --checkpoint=fast --progress
  EOC
end

template "postgresql-9.3" do
  path "/etc/sysconfig/pgsql/postgresql-9.3"
  source "postgresql-9.3.erb"
  owner "root"
  group "root"
  mode 0644
#  notifies :restart, 'service[postgresql-9.3]'
end

template "recovery.conf" do
  path "/var/lib/pgsql/9.3/data/recovery.conf"
  source "recovery.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
#  notifies :reload, 'service[postgresql-9.3]'
end

service "postgresql-9.3" do
  supports :status => true , :restart => true , :reload => true
  action [ :enable, :start ]
end

