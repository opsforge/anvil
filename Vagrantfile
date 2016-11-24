# EULA - All 3rd party components used in this file are the property of their respective owners. The code in this file is the property of OpsForge
# Disclaimer - This setup was tested and proven on Mac OS X 10.10+ . Systems other than this will require manual adjustments pre-deployment from the user
#
# George Svachulay (C) OpsForge . 2016 - All rights reserved
# Requires the subfolder inline-shells and shell scripts to function.

require 'yaml'

Vagrant.configure(2) do |config|
  # Config for DEVOPS TOOLS vagrant box on Virtual Box provider

  config.vm.define 'opsforge' do |opsforge|
    opsforge.vm.provider 'virtualbox' do |vb|
      vb.name = 'opsforge-tools'
      vb.memory = 4096
      vb.customize ['modifyvm', :id, '--natnet1', '192.168.117/24']
    end

    opsforge.vm.host_name = 'opsforge'
    opsforge.vm.box = 'ubuntu/xenial64'

    # Setting shared folders - includes chef config folders and Jungle Disk pem folders

    # Rancher API and UI
    opsforge.vm.network 'forwarded_port', guest: 8080, host: 8080
    # Rancher Load balancers
    opsforge.vm.network 'forwarded_port', guest: 80, host: 80
    opsforge.vm.network 'forwarded_port', guest: 443, host: 443

    # Share files over if necessary
    opsforge.vm.provision 'file', source: '~/shared', destination: '/home/vagrant/shared'

    # Change to devopzsh for ZSH shell or devopsbash for Bash shell
    opsforge.vm.provision :shell, privileged: false, path: 'setup.sh'
  end
end
