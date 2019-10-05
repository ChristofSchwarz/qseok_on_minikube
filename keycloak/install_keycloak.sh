kubectl create -f postgres-pvc.yaml -f postgres-depl.yaml -f postgres-svc.yaml
echo 'Waiting until postgres is ready ...'
kubectl wait --for=condition=available --timeout=600s deployment/postgres
kubectl create -f keycloak-depl-persist.yaml -f keycloak-svc.yaml
echo 'Waiting until keycloak is ready ...'
kubectl wait --for=condition=available --timeout=1800s deployment/keycloak
echo 'Keycloak should now be ready on http://192.168.56.234:32080'
