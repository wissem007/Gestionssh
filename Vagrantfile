# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # p1jenkins4 server
  config.vm.define "jenkins4" do |p1jenkins4|
    p1jenkins4.vm.box = "debian/buster64"
    p1jenkins4.vm.hostname = "jenkins4"
    p1jenkins4.vm.box_url = "debian/buster64"
    p1jenkins4.vm.network :private_network, ip: "192.168.5.10"
    p1jenkins4.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      v.customize ["modifyvm", :id, "--memory", 3048]
      v.customize ["modifyvm", :id, "--name", "jenkins4"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
    end
    config.vm.provision "shell", inline: <<-SHELL
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config	  
      service ssh restart
    SHELL
    p1jenkins4.vm.provision "shell", path: "install_p1jenkins.sh"
  end
end









