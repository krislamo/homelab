# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Machine Name
  config.vm.define :moxie do |moxie| #
  end

  # Disable Machine Name Prefix
  config.vm.provider :libvirt do |libvirt|
    libvirt.default_prefix = ""
  end

  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 2048
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.galaxy_role_file = ENV['ANSIBLE_ROLES_PATH'] + "/requirements.yml"
    ansible.playbook = "dev/" + ENV["PLAYBOOK"] + ".yml"
  end

end
