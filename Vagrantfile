# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos-5.9-x86-64-minimal"
  
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://tag1consulting.com/files/centos-5.9-x86-64-minimal.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./sql", "/home/beerapp/sql"



  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  
   config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = "./chef/cookbooks"
     
     chef.add_recipe "selinux::disabled"
      chef.add_recipe "apache2"
      chef.add_recipe "php"
      chef.add_recipe "mysql"
      chef.add_recipe "yum" 
     chef.add_recipe "python"
     chef.add_recipe "build-essential"
     chef.add_recipe "nodejs::install_from_source_centos"
     chef.add_recipe "beerapp"


  
     # You may also specify custom JSON attributes:
      chef.json = {
        "mysql" => {
          "server_debian_password" => "beer",
          "server_root_password" => "beer",
          "server_repl_password" => "beer",
          "bind_address" => "localhost" 
        },
        "nodejs" => {
          "version" => "0.10.7"
        }
      }
   end

 
end
