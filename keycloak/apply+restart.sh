helm upgrade --install qlik qlik-stable/qliksense -f ~/qliksense.yaml
kubectl delete pod --selector=app=identity-providers
kubectl delete pod --selector=app=edge-auth
