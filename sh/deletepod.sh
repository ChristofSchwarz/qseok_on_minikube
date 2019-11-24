# deletes all pods that match a certain pattern e.g.
# sh deletepod.sh ident   ... will delete pod qlik-identity-providers-65bc75d46-s52q5 
# sh deletepod.sh "edge\|ident" ... will delete pods of 2 matching patterns: edge and ident
kubectl delete $(kubectl get pod -o=name |grep $1)
