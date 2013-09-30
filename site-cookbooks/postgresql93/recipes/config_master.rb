#
# Cookbook Name:: postgresql93
# Recipe:: config_master
#
# Copyright 2013, Uptime Technologies, LLC.
#
# All rights reserved - Do Not Redistribute
#
bash "postgresql93-createuser" do
  only_if { File.exists?("/var/lib/pgsql/9.3/data/postmaster.pid") }
  code <<-EOC
    flag=`/usr/pgsql-9.3/bin/psql -A -t -U postgres -c "select count(*) from pg_roles where rolname = 'replication'" postgres`
    if [ $flag = "0" ]; then
      sudo -u postgres /usr/pgsql-9.3/bin/createuser --no-createdb --no-inherit --login --no-createrole --no-superuser --replication replication
    fi;
  EOC
end

bash "postgresql93-password" do
  only_if { File.exists?("/var/lib/pgsql/9.3/data/postmaster.pid") }
  password = node['postgresql93']['password']
  code <<-EOC
    sudo -u postgres /usr/pgsql-9.3/bin/psql -U postgres -c "alter user postgres with unencrypted password '#{password}'" postgres
  EOC
end

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
  source "pg_hba.conf.replication.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, 'service[postgresql-9.3]'
end

service "postgresql-9.3" do
  supports :status => true , :restart => true , :reload => true
  action [ :reload, :restart ]
end

