kubectl create -f postgres-pvc.yaml -f postgres-depl.yaml -f postgres-svc.yaml
echo 'Waiting until postgres is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/postgres
kubectl create -f keycloak-depl-persist.yaml -f keycloak-svc.yaml
echo 'Waiting until keycloak is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/keycloak

KEYCLOAKURL="http://192.168.56.234:32080"
echo 'Keycloak should now be ready on $KEYCLOAKURL in the next 2 minutes'
until $(curl -s --output /dev/null --connect-timeout 5 --max-time 6 --head --fail $KEYCLOAKURL/auth); do
    echo "waiting for response at $KEYCLOAKURL/auth"
    sleep 5
done
echo 'Now ready.'
