echo 'execute "7_mongo.sh"'

echo 'Creating PVC for MongoDB'
kubectl apply -f ~/yaml/pvc_mongo.yaml

echo 'Installing MongoDB chart'
#helm init
#helm repo update
helm install -n mongo stable/mongodb -f ~/yaml/mongo.yaml 
