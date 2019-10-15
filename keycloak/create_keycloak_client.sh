echo "Installing Node JS ..."
sudo apt-get install nodejs -y
echo "Installing Json Query tool 'jq' ..."
sudo apt-get install jq -y

KEYCLOAKURL="http://192.168.56.234:32080"

echo "Get keycloak access_token $KEYCLOAKURL ..."
TKN=$(curl -s \
  -X POST "$KEYCLOAKURL/auth/realms/master/protocol/openid-connect/token" \
  -d "username=admin" \
  -d "password=admin" \
  -d "client_id=admin-cli" \
  -d "grant_type=password" | jq '.access_token' -r)

echo "$TKN"
echo "Creating Keycloak Client ..."
# remove newline from .json
CLIENTJSON=$(tr -d '\r\n' <kc-client-settings.json)

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

OLDSECRET=$(cat qliksense-keycloak.yaml|grep clientSecret|grep -o '".*"'|sed 's/"//g')
echo "Old secret is $OLDSECRET"
echo "New secret is $CLIENTSECRET"
echo "Updating in qliksense-keycloak.yaml"

sed -i "s/$OLDSECRET/$CLIENTSECRET/g" qliksense-keycloak.yaml


echo 'Creating Keycloak User "api"...'
# remove newline from .json
USERJSON=$(tr -d '\r\n' <kc-user-settings.json)

curl -s \
  -X POST "$KEYCLOAKURL/auth/admin/realms/master/users" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json" \
  -d "$USERJSON"


echo "Getting new user's id ..."
USERID=$(curl -s \
  -X GET "$KEYCLOAKURL/auth/admin/realms/master/users?username=api" \
  -H "Authorization: Bearer $TKN" \
 | jq '.[0].id' -r)

echo "Set password of user $USERID ..."

curl -s \
  -X PUT "$KEYCLOAKURL/auth/admin/realms/master/users/$USERID/reset-password" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json" \
  -d '{"type":"password","value":"Qlik1234","temporary":false}'

echo "Password for user 'api' set to 'Qlik1234'"

nodejs createjwt.js $USERID >apiuser_jwt.txt

read -p "apply changes (helm upgrade) to qlik deployment now (y/n)? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  helm upgrade --install qlik qlik-stable/qliksense -f qliksense-keycloak.yaml
  kubectl delete pod --selector=app=identity-providers
  kubectl delete pod --selector=app=edge-auth
fi

echo 'This is the JWT Bearer token for api user (found in apiuser_jwt.txt):'
cat apiuser_jwt.txt
