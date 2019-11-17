Vagrant.configure("2") do |config|  
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.hostname = "qliksense-minikube"
  config.vm.network "private_network", ip: "192.168.56.234"
  config.vm.provider "virtualbox" do |v|
    v.name = "qliksense-minikube"
    v.linked_clone = true
    v.customize ["modifyvm", :id, "--memory", 8192]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--vram", 64]
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    v.customize ["modifyvm", :id, "--chipset", "ich9"]
  end  
  config.vm.synced_folder "./yaml", "/vagrant/yaml"
  config.vm.synced_folder "./keycloak", "/vagrant/keycloak"  
  config.vm.synced_folder "./sh", "/vagrant/sh" 
  config.vm.synced_folder "./api", "/vagrant/api" 
  #the following .sh files are executed as root: 1, 3, 4
  config.vm.provision "boot", type: "shell", path: "./sh/1_bootstrap.sh"
  config.vm.provision "vagr", type: "shell", path: "./sh/2_uservagrant.sh", privileged: false 
  config.vm.provision "dock", type: "shell", path: "./sh/3_docker.sh"
  config.vm.provision "mk8s", type: "shell", path: "./sh/4_minikube.sh"
  #next .sh files are executed as vagrant user, not as root (privileged false)
  config.vm.provision "helm", type: "shell", path: "./sh/5_helm.sh", privileged: false 
  config.vm.provision "nfs_", type: "shell", path: "./sh/6_nfs.sh", privileged: false 
  config.vm.provision "mong", type: "shell", path: "./sh/7_mongo.sh", privileged: false 
  config.vm.provision "keyc", type: "shell", path: "./sh/8_keycloak.sh", privileged: false 
  config.vm.provision "qlik", type: "shell", path: "./sh/9_qliksense.sh", privileged: false 
end
