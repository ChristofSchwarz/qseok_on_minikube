echo "Running 7_keycloak.sh ..."

echo "Copying keycloak folder to vagrant's home folder"
mkdir ~/keycloak
cp -R /vagrant/keycloak/* ~/keycloak

echo "Installing Node JS ..."
sudo apt-get install nodejs -y
echo "Installing Json Query tool 'jq' ..."
sudo apt-get install jq -y

echo "Deploying postgres ..."
kubectl create -f ~/keycloak/postgres-pvc.yaml 
kubectl create -f ~/keycloak/postgres-depl.yaml 
kubectl create -f ~/keycloak/postgres-svc.yaml
echo 'Waiting until postgres is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/postgres

echo "Deploying keycloak ..."
kubectl create -f ~/keycloak/keycloak-depl-persist.yaml 
kubectl create -f ~/keycloak/keycloak-svc.yaml
echo 'Waiting until keycloak is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/keycloak

KEYCLOAKURL="http://192.168.56.234:32080"
until $(curl -s --output /dev/null --connect-timeout 5 --max-time 6 --head --fail $KEYCLOAKURL/auth); do
    echo "waiting for response at $KEYCLOAKURL/auth"
    sleep 5
done

echo "Get keycloak access_token ..."
TKN=$(curl -s \
  -X POST "$KEYCLOAKURL/auth/realms/master/protocol/openid-connect/token" \
  -d "username=admin" \
  -d "password=admin" \
  -d "client_id=admin-cli" \
  -d "grant_type=password" | jq '.access_token' -r)

KEYCLOAKURL="http://192.168.56.234:32080"

echo "Get keycloak access_token $KEYCLOAKURL ..."
TKN=$(curl -s \
  -X POST "$KEYCLOAKURL/auth/realms/master/protocol/openid-connect/token" \
  -d "username=admin" \
  -d "password=admin" \
  -d "client_id=admin-cli" \
  -d "grant_type=password" | jq '.access_token' -r)

echo "Changing theme to qliktheme"
curl -s \
  -X PUT "$KEYCLOAKURL/auth/admin/realms/master" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json" \
  -d '{"loginTheme":"qliktheme"}'

echo "Creating Keycloak Client ..."
# remove newline from .json
CLIENTJSON=$(tr -d '\r\n' <~/keycloak/kc-client-settings.json)

curl -s \
  -X POST "$KEYCLOAKURL/auth/admin/realms/master/clients" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json" \
  -d "$CLIENTJSON"

echo "get new client's id ..."
# it is using jq library which we installed above.
CLIENTID=$(curl -s \
  -X GET "$KEYCLOAKURL/auth/admin/realms/master/clients?clientId=qliklogin" \
  -H "Authorization: Bearer $TKN" \
 | jq '.[0].id' -r)

echo "Get secret of client $CLIENTID"

CLIENTSECRET=$(curl -s \
  -X GET "$KEYCLOAKURL/auth/admin/realms/master/clients/$CLIENTID/client-secret" \
  -H "Authorization: Bearer $TKN" \
 | jq '.value' -r)

OLDSECRET=$(cat ~/keycloak/qliksense-keycloak.yaml|grep clientSecret|grep -o '".*"'|sed 's/"//g')
echo "Old secret is $OLDSECRET"
echo "New secret is $CLIENTSECRET"
echo "Updating in qliksense-keycloak.yaml"

sed -i "s/$OLDSECRET/$CLIENTSECRET/g" ~/keycloak/qliksense-keycloak.yaml

