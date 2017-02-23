# EULA - All 3rd party components used in this file are the property of their respective owners. The code in this file is the property of OpsForge
# Disclaimer - This setup was tested and proven on Mac OS X 10.10+ . Systems other than this will require manual adjustments pre-deployment from the user
#
# Copyright (C) 2017 George Svachulay - Apache 2.0 License
# Requires the subfolder inline-shells and shell scripts to function.

require 'yaml'

Vagrant.configure(2) do |config|
  # Config for DEVOPS TOOLS vagrant box on Virtual Box provider

  config.vm.define 'opsforge' do |opsforge|
    opsforge.vm.provider 'virtualbox' do |vb|
      vb.name = 'opsforge-tools'
      # Default recommended RAM is 4GB - min. is 2GB (with 4GB you can run multiple services on Rancher safely)
      vb.memory = 4096
      # The below nat IP CIDR definition will always result in 192.168.117.15 - so consider it a static IP (guest internal only, due to NAT)
      vb.customize ['modifyvm', :id, '--natnet1', '192.168.117.0/24']
    end

    opsforge.vm.host_name = 'opsforge'
    opsforge.vm.box = 'centos/7'

    # Setting shared folders - includes chef config folders and Jungle Disk pem folders

    # Rancher API and UI
    opsforge.vm.network 'forwarded_port', guest: 8080, host: 8080
    # Default port for opsforge
    opsforge.vm.network 'forwarded_port', guest: 8001, host: 8001
    # Default port for cloud9
    opsforge.vm.network 'forwarded_port', guest: 8181, host: 8181
    # Default port for HTTPS pages
    opsforge.vm.network 'forwarded_port', guest: 443, host: 443
    # Default port for Puppet
    opsforge.vm.network 'forwarded_port', guest: 8140, host: 8140
    # Default port for PuppetDB
    opsforge.vm.network 'forwarded_port', guest: 8081, host: 8081

    config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    # Change to devopzsh for ZSH shell or devopsbash for Bash shell
    opsforge.vm.provision :shell, privileged: false, path: './setup-rhn.sh'
  end
end
