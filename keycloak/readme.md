# Using Keycloak as Identity Provider for QSEoK

**Info:** Keycloak is an open source software product to allow single sign-on with Identity Management and Access Management, maintained by JBoss community project and under the stewardship of Red Hat. The tool's intent is to make it easy to secure applications and services with little to no coding.
The steps below will start keycloak as a K8s deployment and expose it as a service for your Minikube (NodePort). If deployed on a production cluster, you may need the service type "LoadBalancer". In this case, edit the `keycloak-svc.yaml` file first. 

## Quick and easy setup

 * if you don't want to understand the background, just do this from your shell (login as vagrant vagrant)
```
cd ~/keycloak
sh install_keycloak.sh  # can take over 10 minutes ...
sh create_keycloak_client.sh
```
 * the last shell-file will prompt you, if you like to apply the changes to the qlik deployment (using helm upgrade). Enter "y" and wait until the changes are applied to qlik and 2 pods are restarted
 * Qlik Sense is accessible at https://192.168.56.234 (no change in hosts. file needed) with all users you create in Keycloak 
 * Qlik Sense uses Keycloak as identity-provider (enter console at http://192.168.56.234:32080 with admin admin)
 
## Explanation of the steps in detail

### 1) Start keycloak in your cluster
The simpliest case is Keycloak *without* persistence. You will need two objects (a deployment and a service):
```
kubectl create -f keycloak-depl-nopersist.yaml -f keycloak-svc.yaml
```
If you want to persist the Keycloak settings (which I recommend), you have to first install a persisted Postgres DB (has a pvc, a deployment, and a service):
```
kubectl create -f postgres-pvc.yaml -f postgres-depl.yaml -f postgres-svc.yaml
kubectl create -f keycloak-depl-persist.yaml -f keycloak-svc.yaml
```
![alttext](https://github.com/ChristofSchwarz/pics/raw/master/keycloak-opts.png "screenshot")

**Note:** Keycloak is a large deployment, it can take 10 min+ until it becomes ready. The command to check the status of just the keycloak pod is: wait until it is running.
```
kubectl wait --for=condition=available --timeout=1800s deployment/keycloak
```
Those reads helped me with setting up Keycloak on Postgres https://www.dirigible.io/blogs/2018/06/25/kubernetes_keycloak_postgresql_dirigible.html , https://severalnines.com/database-blog/using-kubernetes-deploy-postgresql , https://github.com/peterzandbergen/keycloak-kubernetes.


### 2) Create a client on Keycloak to authenticate QSEoK users

#### Manual steps
 * Navigate your browser to http://192.168.56.234:32080/auth/admin/master/console/#/create/client/master (thats the "Create Client" dialog in the Keycloak Administration Console)
 * Login with "admin" "admin"
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/kc-client-settings.json">.json file</a> from this git, then click Import Select file from the Keycloak console.
 * This will create a new client called "qliklogin" (two Mappers have been added, too: name and email)
![alttext](https://github.com/ChristofSchwarz/pics/raw/master/_keycloak.png "screenshot") 
 * If your deployment is not on 192.168.56.234 please update the redirect_url of the new Keycloak client accordingly
 * Go to sheet "Credentials" and note the Secret-ID
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/qliksense.yaml">.yaml file</a> and edit the Client-Secret before you apply the changes with "helm upgrade ..."

#### Create the client with Keycloak REST API
 * Use the Json parser tool <a href="https://stedolan.github.io/jq/download/">jq</a>.
```
sudo apt-get install jq -y
```
 * Get an access token
```
curl -X POST http://192.168.56.234:32080/auth/realms/master/protocol/openid-connect/token -d "username=admin&password=admin&client_id=admin-cli&grant_type=password" | jq '.access_token' -r
```
 * with this access_token you've got 60 seconds to create a client, likely too short to do it manually, therefore I put this into a this <a href="create_keycloak_client.sh">shell script</a>.


### 3) Upgrade Qlik Sense deployment (configure IDP)

It assumes Qlik Sense to be installed on IP 192.168.56.234 (the vagrant box we provisioned in this .git), if yours is different, pls edit the configuration first (redirect_url in the Keycloak Console and the qliksense.yaml file for helm upgrade ...)

```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
 * if you upgraded a Qlik Sense deployment (not first-time installed it now) then you have to manually restart the pod "qlik-identity-providers-#######" and "qlik-edge-auth-#######":
```
kubectl delete pod --selector=app=identity-providers
kubectl delete pod --selector=app=edge-auth
```
 * you can now login to Qlik Sense with the keycloak user "admin" by going to https://192.168.56.234/ (because you already logged in, this happens without further prompting. You can check who you are logged in as by going to https://192.168.56.234/api/v1/users/me)
 * You can go to the Keycloak console and create more users, but none will be persisted if the keycloak pod is stopped.
 
## Remove Keycloak
To remove the deployments and the services we installed before, run this <a href="delete_keycloak.sh">shell script</a>. It will remove all Kubernetes objects of keycloak and postgres we installed above.
```
sh delete_keycloak.sh
```


## Errors in QSEoK 
The configuration of the identity-provider can lead to some error messages by Qlik Sense:
```
{"errors":[{"title":"No authentication configured for this hostname","code":"LOGIN-2","status":"401"}]}
{"errors":[{"title":"Invalid identity provider configuration","code":"INVALID-IDP-CONFIG","status":"401"}]}
```


