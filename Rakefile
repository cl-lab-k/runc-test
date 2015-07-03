#
# Rakefile Name:: vms
#
# Copyright (c) 2015 CREATIONLINE,INC. All Rights Reserved.
#

#
# berks
#
desc 'berks vendor'
task :vendor do
  sh 'berks vendor cookbooks'
end

#
# vagrant
#
desc 'vagrant up'
task :up do
  sh 'vagrant up'
end

#
# destroy
#
desc 'vagrant destroy'
task :destroy do
  sh 'vagrant destroy -f'
end

task :default => [ :vendor, :up ]

#
# [EOF]
#
