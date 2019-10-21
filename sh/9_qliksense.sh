echo 'executing "9_qliksense.sh" ...'
#
#echo 'Adding stable and edge repo from qlik.bintray.com'
#helm repo add qlik-stable https://qlik.bintray.com/stable
#helm repo add qlik-edge https://qlik.bintray.com/edge
#helm init
#helm repo update
#
echo 'installing stable "qliksense-init"'
helm upgrade --install qlikinit qlik-stable/qliksense-init
#
cp ~/keycloak/qliksense-template.yaml ~/qliksense.yaml
cat ~/api/public.key|sed 's/\(.*\)/            \1/'>>~/qliksense.yaml
#
echo 'installing stable "qliksense"'
helm upgrade --install qlik qlik-stable/qliksense -f ~/qliksense.yaml
#
BEARER=$(nodejs ~/api/createjwt.js admin)
echo "JWT user token is:"
echo "$BEARER"
SITELICENSE=$(cat ~/api/sitelicense.txt)
HOST=https://192.168.56.234
STARTLOOP=$(date)
#
until $(curl -s --output /dev/null --connect-timeout 5 --max-time 6 --head --fail $HOST/api/v1/users); do
    echo "Waiting for response at $HOST since $STARTLOOP."
    echo "The following pods aren't ready yet (retry in 30s):"
    kubectl get pods | grep -v Running
    sleep 30
done
#
TENANT=$(curl --insecure -s \
  -X GET "$HOST/api/v1/users" \
  -H "Authorization: Bearer $BEARER"|jq '.data[0].tenantId' -r)
#
echo "You are tenant $TENANT"
#
curl --insecure -s \
  -X PUT "$HOST/api/v1/tenants/$TENANT/licenseDefinition" \
  -H "Authorization: Bearer $BEARER" \
  -H "Content-Type: application/json" \
  -d '{"key":"$SITELICENSE"}'
echo ""
#
curl --insecure \
  -X GET "$HOST/api/v1/licenses/overview" \
  -H "Authorization: Bearer $BEARER" \
  -H "Content-Type: application/json"
echo ""
#

