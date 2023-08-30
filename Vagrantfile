# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
settings_path = '.vagrant.yml'
settings = {}

if File.exist?(settings_path)
  settings = YAML.load_file(settings_path)
end

VAGRANT_BOX  = settings['VAGRANT_BOX']  || 'debian/bookworm64'
VAGRANT_CPUS = settings['VAGRANT_CPUS'] || 2
VAGRANT_MEM  = settings['VAGRANT_MEM']  || 2048
SSH_FORWARD  = settings['SSH_FORWARD']  || false

# Default to shell environment variable: PLAYBOOK (priority #1)
PLAYBOOK=ENV["PLAYBOOK"]
if !PLAYBOOK || PLAYBOOK.empty?
  # PLAYBOOK setting in .vagrant.yml (priority #2)
  PLAYBOOK = settings['PLAYBOOK'] || 'default'
end

Vagrant.configure("2") do |config|
  config.vm.box = VAGRANT_BOX
  config.vm.network "private_network", type: "dhcp"
  config.ssh.forward_agent = SSH_FORWARD

  # Libvrit provider
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus   = VAGRANT_CPUS
    libvirt.memory = VAGRANT_MEM
  end

  # Virtualbox provider
  config.vm.provider :virtualbox do |vbox|
    vbox.cpus   = VAGRANT_CPUS
    vbox.memory = VAGRANT_MEM
  end

  # Provision with Ansible
  config.vm.provision "ansible" do |ansible|
    ENV['ANSIBLE_ROLES_PATH'] = File.dirname(__FILE__) + "/roles"
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "dev/" + PLAYBOOK + ".yml"
  end
end
