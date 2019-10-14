
echo 'executing 7_qliksense.sh ...'

echo 'Adding stable and edge reop from qlik.bintray.com'
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge
helm init
helm repo update

echo "copying yaml and keycloak folder to vagrant's home folder"
mkdir ~/yaml
cp /vagrant/yaml/* ~/yaml
mkdir ~/keycloak
cp /vagrant/keycloak/* ~/keycloak

echo 'installing stable "qliksense-init"'
helm upgrade --install qlikinit qlik-stable/qliksense-init

echo 'installing stable "qliksense"'
helm upgrade --install qlik qlik-stable/qliksense -f yaml/qliksense-simple.yaml 
