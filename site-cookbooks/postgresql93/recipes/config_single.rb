#
# Cookbook Name:: postgresql93
# Recipe:: config_single
#
# Copyright 2013, Uptime Technologies, LLC.
#
# All rights reserved - Do Not Redistribute
#
template "postgresql.conf" do
  path "/var/lib/pgsql/9.3/data/postgresql.conf"
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, 'service[postgresql-9.3]'
end

template "pg_hba.conf" do
  path "/var/lib/pgsql/9.3/data/pg_hba.conf"
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, 'service[postgresql-9.3]'
end

