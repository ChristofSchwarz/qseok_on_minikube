echo ---audit--->logs.json
echo ---audit---
kubectl logs --selector app=audit >>logs.json
echo ---edge-auth--->>logs.json
echo ---edge-auth---
kubectl logs --selector app=edge-auth>>logs.json
echo ---qlik-engine--->>logs.json
echo ---qlik-engine---
kubectl logs --selector app=qlik-engine>>logs.json
echo ---identity-providers--->>logs.json
echo ---identity-providers---
kubectl logs --selector app=identity-providers>>logs.json
echo ---licenses/licenses--->>logs.json
echo ---licenses/licenses---
kubectl logs --selector app=licenses -c licenses>>logs.json
echo ---qix-data-connection--->>logs.json
echo ---qix-data-connection---
kubectl logs --selector app=qix-data-connection>>logs.json
echo ---qix-sessions--->>logs.json
echo ---qix-sessions---
kubectl logs --selector app=qix-sessions>>logs.json
echo Done. See file logs.json
