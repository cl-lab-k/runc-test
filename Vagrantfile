Vagrant.configure("2") do |config|
  config.vm.box = 'chef/ubuntu-14.04'

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box 
  end

  config.vm.network 'private_network', ip: '192.168.33.101'
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end

  config.vm.provision 'chef_zero' do |chef|
    chef.cookbooks_path = 'cookbooks'
    chef.nodes_path = 'nodes'

    chef.add_recipe 'build-essential'
    chef.add_recipe 'golang'
    chef.add_recipe 'runc-test'
  end
end
