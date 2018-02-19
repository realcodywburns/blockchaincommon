# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.box_download_checksum_type = "sha256"
   config.vm.box_download_checksum = "01d45caaa1b059258bb2034e547928767f3003526d08c5099b18a1275bdd8dba"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  #config.vm.network 'forwarded_port', guest: 8080, host: 8080
  #ethereum ports
  #config.vm.network 'forwarded_port', guest: 8545, host: 8545
  #config.vm.network 'forwarded_port', guest: 30303, host: 30303

  # Hyperledger Fabric ports
  config.vm.network 'forwarded_port', guest: 7050, host: 7050
  config.vm.network 'forwarded_port', guest: 7051, host: 7051
  config.vm.network 'forwarded_port', guest: 7052, host: 7052
  config.vm.network 'forwarded_port', guest: 7053, host: 7053
  config.vm.network 'forwarded_port', guest: 7054, host: 7054

  config.vm.network 'forwarded_port', guest: 3100, host: 3100
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 4200, host: 4200
  config.vm.network 'forwarded_port', guest: 8080, host: 8080 # explorer
  config.vm.network 'forwarded_port', guest: 5984, host: 5984 # couch
 # Zcash - p2p port and rpc port
  #config.vm.network 'forwarded_port', guest: 8233, host: 8233
  #config.vm.network 'forwarded_port', guest: 8232, host: 8232

 # Apache2
  config.vm.network 'forwarded_port', guest: 80, host: 120

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end

  config.vm.provider "parallels" do |prl|
    prl.update_guest_tools = true

    prl.customize ["set", :id, "--startup-view", "same"]

    prl.memory = 4096
  end

  # Execute provision script to configure the rest
  config.vm.provision :shell, path: "bootstrap.sh"

end
