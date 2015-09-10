# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.box_check_update = true
  config.vm.network :private_network, ip: '192.168.37.12'
  config.vm.synced_folder "../feed", "/var/pyramid/project_files"

  config.vm.provision "shell", path: "bootstrap.sh"
end
