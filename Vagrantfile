# -*- mode: ruby -*-
# vi: set ft=ruby :

SSH_FORWARD=ENV["SSH_FORWARD"]
if !(SSH_FORWARD == "true")
  SSH_FORWARD = false
end

PLAYBOOK=ENV["PLAYBOOK"]
if !PLAYBOOK
  if File.exist?('.playbook')
    PLAYBOOK = IO.read('.playbook').split("\n")[0]
  end

  if !PLAYBOOK || PLAYBOOK.empty?
    PLAYBOOK = "\nERROR: Set env PLAYBOOK"
  end
else
  File.write(".playbook", PLAYBOOK)
end

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./scratch", "/vagrant/scratch"
  config.ssh.forward_agent = SSH_FORWARD

  # Machine Name
  config.vm.define :moxie do |moxie| #
  end

  # Disable Machine Name Prefix
  config.vm.provider :libvirt do |libvirt|
    libvirt.default_prefix = ""
  end

  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 4096
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "dev/" + PLAYBOOK + ".yml"
  end

end
