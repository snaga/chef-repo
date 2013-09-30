#
# Cookbook Name:: postgresql93
# Recipe:: initdb
#
# Copyright 2013, Uptime Technologies, LLC.
#
# All rights reserved - Do Not Redistribute
#
bash "postgresql93-initdb" do
  not_if { File.exists?("/var/lib/pgsql/9.3/data/PG_VERSION") }
  code <<-EOC
    sudo -u postgres /usr/pgsql-9.3/bin/initdb -D /var/lib/pgsql/9.3/data --no-locale -E UTF-8 -k
  EOC
end

template "postgresql-9.3" do
  path "/etc/sysconfig/pgsql/postgresql-9.3"
  source "postgresql-9.3.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[postgresql-9.3]'
end

service "postgresql-9.3" do
  supports :status => true , :restart => true , :reload => true
  action [ :enable, :start ]
end

bash "postgresql93-password" do
  only_if { File.exists?("/var/lib/pgsql/9.3/data/PG_VERSION") }
  password = node['postgresql93']['password']
  code <<-EOC
    sudo -u postgres /usr/pgsql-9.3/bin/psql -U postgres -c "alter user postgres with unencrypted password '#{password}'" postgres
  EOC
end

