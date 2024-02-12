# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.

  #nodes = {
   #"vm-multi1" => ["bento/ubuntu-18.04", 1, 1024, "00:50:56:19:01:96"],
   #"vm-multi2" => ["bento/ubuntu-18.04", 2, 2048, "00:50:56:19:01:97"],
#}
IMAGE_NAME = "generic/debian11"   # Image to use
MEM = 4096                          # Amount of RAM
CPU = 2                             # Number of processors (Minimum value of 2 otherwise it will not work)
MASTER_NAME="bind9-pipeline"

NODE_NETWORK_BASE = "192.168.45"    # First three octets of the IP address that will be assign to all type of nodes

nodes = [
  { hostname: MASTER_NAME, box: "generic/debian11", mac:'00:51:56:51:87:95', numvcpus:'2', memsize:'2048', storage:'datastore1', ip:"#{NODE_NETWORK_BASE}.9" }
]
Vagrant.configure("2") do |config|
  #config.vm.synced_folder('.', '/vagrant', type: 'nfs', disabled: true)
 #   config.vm.provision "shell", path: "roles/master/files/install_p1jenkins.sh"

  nodes.each do |node|
    #box, numvcpus, memory, mac = cfg

  config.vm.define node[:hostname] do |config|
    config.vm.synced_folder('.', '/Vagrantfiles', type: 'rsync')
    config.vm.box = node[:box]
    config.vm.hostname= node[:hostname]
#    config.vm.disk :disk, size: "20GB", primary: true
    config.vm.boot_timeout = 100
    config.vm.graceful_halt_timeout = 100
    #config.vm.network "private_network", ip: "192.168.10.50"
    config.ssh.insert_key = false
    config.ssh.private_key_path = [
      '~/.ssh/id_rsa',
      '~/.vagrant.d/insecure_private_key'
    ]
    config.vm.provision 'file', 
      source: '~/.ssh/id_rsa.pub', 
      destination: '~/.ssh/authorized_keys'

       # Ansible role setting
       config.vm.provision :ansible do |ansible|
        #resume.start_at_task = ENV['START_AT_TASK']
        # Ansbile role that will be launched
        ansible.playbook = "roles/main.yml"
        #ansible.start_at_task = ENV['add auto completion kubectl']
        #ansible.raw_arguments = ['--tags=master, worker']
         #ansible.raw_arguments = ['--list-tasks']
        #ansible.tags = ['flannel1'] # master ou worker
        # Groups in Ansible inventory
        ansible.groups = {
            "masters" => ["#{MASTER_NAME}"],
        }

        # Overload Anqible variables
        ansible.extra_vars = {
            gateway: "#{NODE_NETWORK_BASE}.2",
            srv_ip: node[:ip],
            dns1: "192.168.45.9",
            dns2: "192.168.45.10",
            dns3: "1.1.1.1",
            domain: "vlne.lan"
            
        }

        
  config.vm.provider :vmware_esxi do |esxi|
    esxi.esxi_hostname = "192.168.45.135"
    esxi.esxi_username = "root"
    esxi.esxi_password = "password"
    esxi.esxi_virtual_network = ['LAN']
    esxi.esxi_disk_store = node[:storage]
    esxi.guest_memsize = node[:memsize]
    esxi.guest_numvcpus = node[:numvcpus]
    esxi.guest_virtualhw_version = '11'
    esxi.debug = "true"
    #esxi.guest_custom_vmx_set
    esxi.guest_nic_type = 'vmxnet3'
    esxi.guest_disk_type = 'thin'
    esxi.guest_boot_disk_size = 40
    #esxi.guest_boot_disk_size = 40tings = [['ide0:0.present','FALSE'], ['ide0:0.filename','']]
    esxi.guest_mac_address = [node[:mac]]
    end  
  end
end
end
end
