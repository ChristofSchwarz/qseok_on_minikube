echo 'executing "6_nfs.sh"'

echo 'Installing storageClass on NFS provider'
#helm init
#helm repo update
helm install -n nfs stable/nfs-client-provisioner -f ~/yaml/storageClass.yaml

echo 'Installing PVC on above storageClass'
kubectl apply -f ~/yaml/pvc_nfs.yaml
