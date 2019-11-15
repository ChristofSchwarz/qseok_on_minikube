echo 'Executing "2_uservagrant.sh" ...'

echo "Installing Node JS ..."
sudo apt-get install nodejs -y
echo "Installing Node Package Manager npm ..."
sudo apt-get install npm -y
echo "Installing Json Query tool 'jq' ..."
sudo apt-get install jq -y

echo "Copying folders to vagrant's home folder"
mkdir ~/yaml
cp -R /vagrant/yaml/* ~/yaml

mkdir ~/keycloak
cp -R /vagrant/keycloak/* ~/keycloak

mkdir ~/api
cp -R /vagrant/api/* ~/api
cd ~/api

echo "Creating private/public key pair in ~/api folder"
openssl genrsa -out ~/api/private.key 1024
openssl rsa -in ~/api/private.key -pubout -out ~/api/public.key

echo "Installing NodeJS packages fs, jsonwebtoken"
npm install fs
npm install jsonwebtoken
