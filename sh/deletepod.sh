# deletes all pods that match a certain pattern e.g.
# sh deletepod.sh ident   ... will delete pod qlik-identity-providers-65bc75d46-s52q5 
kubectl delete $(kubectl get pod -o=name |grep $1)
