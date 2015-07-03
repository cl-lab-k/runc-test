#
# Cookbook Name:: runc-test
# Recipe:: default
#
# Copyright (c) 2015 CREATIONLINE,INC. All Rights Reserved.
#

group 'root' do
  action :modify
  members 'vagrant'
  append true
end

#
# preparing for runc
#
docker_service 'default' do
  action [ :create, :start ]
end

docker_image 'chef/ubuntu-14.04:latest' do
  action :pull
end

docker_container 'an echo server' do
  image 'chef/ubuntu-14.04:latest'
  port '1234:1234'
  command 'nc -ll -p 1234 -e /bin/cat'
  detach true
  init_type false 
  action :run
end

docker_container 'chef/ubuntu-14.04:latest' do
  destination '/tmp/ubuntu-14.04.tar'
  action :export
end

directory '/tmp/container/rootfs' do
  owner 'vagrant'
  group 'vagrant'
  mode 0755
  recursive true
end

execute 'extract chef/ubuntu-14.04:latest' do
  user  'root'
  group 'root'
  command 'tar xf /tmp/ubuntu-14.04.tar -C /tmp/container/rootfs'
  not_if { ::File.exists?( '/tmp/container/rootfs/var' ) }
end

cookbook_file '/tmp/container/config.json' do
  source 'config.json'
  owner 'vagrant'
  group 'vagrant'
  mode 0644
end

#
# build runc
#
directory '/home/vagrant/golang/src/github.com/opencontainers' do
  mode 0755
  recursive true
end

git '/home/vagrant/golang/src/github.com/opencontainers/runc' do
  repository 'https://github.com/opencontainers/runc.git'
  revision 'master'
  action :sync
end

execute 'build runc' do
  cwd '/home/vagrant/golang/src/github.com/opencontainers/runc'
  environment(
    'GOPATH' => '/home/vagrant/golang',
    'PATH' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/go/bin:/opt/go/bin'
  )
  command 'make all install'
  not_if { ::File.exists?( '/usr/local/bin/runc' ) }
end

#
# [EOF]
#
