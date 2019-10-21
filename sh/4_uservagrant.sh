echo 'Executing "5_usersvagrant.sh" ...'

echo "Copying folders to vagrant's home folder"
mkdir ~/yaml
cp -R /vagrant/yaml/* ~/yaml

mkdir ~/keycloak
cp -R /vagrant/keycloak/* ~/keycloak

mkdir ~/api
cp -R /vagrant/keycloak/* ~/api

echo "Installing Node JS ..."
sudo apt-get install nodejs -y
echo "Installing Json Query tool 'jq' ..."
sudo apt-get install jq -y

