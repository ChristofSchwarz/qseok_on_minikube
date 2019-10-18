echo 'executing "1_bootstrap.sh"'
echo 'Updating Ubuntu'
#sudo apt-get -qq -y update

echo 'Installing git nfs-kernel-server'
#sudo apt-get install -qq git nfs-kernel-server

echo 'Disabling swap'
sudo swapoff -a

echo "copying yaml and keycloak folder to vagrant's home folder"
mkdir /home/vagrant/yaml
cp -R /vagrant/yaml/* /home/vagrant/yaml
mkdir /home/vagrant/keycloak
cp -R /vagrant/keycloak/* /home/vagrant/keycloak

# Comment the swap line from fstab - permanently disable swap
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#NFS
sudo mkdir -p /export/k8s
sudo mkdir -p /export/src
sudo chown nobody:nogroup /export/k8s
sudo bash -c 'cat << EOF >>/etc/exports
/export/k8s   *(rw,sync,no_subtree_check,no_root_squash)
/export/src  *(rw,sync,no_subtree_check,no_root_squash)
/export       *(rw,fsid=0,no_subtree_check,sync)
EOF'
echo 'Starting NFS Kernel server'
sudo service nfs-kernel-server restart

#echo 'Adding name server'
#sudo  sed -i '1s/^/nameserver 8.8.8.8 /' /etc/resolv.conf
