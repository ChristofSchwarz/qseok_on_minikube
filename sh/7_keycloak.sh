echo "Running 7_keycloak.sh ..."

kubectl create -f ~/keycloak/postgres-pvc.yaml 
kubectl create -f ~/keycloak/postgres-depl.yaml 
kubectl create -f ~/keycloak/postgres-svc.yaml
echo 'Waiting until postgres is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/postgres

kubectl create -f ~/keycloak/keycloak-depl-persist.yaml 
kubectl create -f ~/keycloak/keycloak-svc.yaml
echo 'Waiting until keycloak is ready ...'
kubectl wait --for=condition=available --timeout=3600s deployment/keycloak

echo 'Keycloak should soon be ready at http://192.168.56.234:32080'
