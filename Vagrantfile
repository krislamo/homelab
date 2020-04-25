# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.network :private_network, ip: "192.168.111.222"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Machine Name
  config.vm.define :moxie do |moxie| #
  end

  # Disable Machine Name Prefix
  config.vm.provider :libvirt do |libvirt|
    libvirt.default_prefix = ""
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = ENV["PLAYBOOK"] + ".yml"
    ansible.inventory_path = "environments/development/vagrant"
    ansible.limit = ENV["PLAYBOOK"]

  end

end
