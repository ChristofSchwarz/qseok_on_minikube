# Qlik Sense Enterprise on Minikube

Status: 05-Oct-2019

*Note:* This is a newer version of repository https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision. The video about installing it https://youtu.be/dhQowB_Q9xU is still acurate to the point that this one already installs Qlik Sense Enterprise on Kubernetes and it uses port 443 (https) instead of 32443. 

The container-creation for all pods of qliksense deployment takes **quite some time**, on slower networks like 60-90 minutes.

Check if all pods are ready with 
```
kubectl get pods
```
This installation first starts using Qlik's built-in simple OIDC, so you don't need an Identity Provider.
 * you must set your hosts. file of the computer which connects to qlik sense to resolve "elastic.example". On Windows, the hosts file is under C:\Windows\System32\drivers\etc\hosts and must be edited as Admin.
```
192.168.56.234 elastic.example
```
 * then connect to https://elastic.example , accept the warning of the self-signed certificate, you will be taken to a simple login-page with 10 hard-coded users described here https://support.qlik.com/articles/000076585
 
 * alternatively, you can install, and switch to, Keycloak, where you can setup users as needed

## using Keycloak as IDP for QSEoK

 * if you don't want to understand the background, just do this from your shell (login as vagrant vagrant)
```
cd ~/keycloak

sh create_keycloak_client.sh
```
See <a href="keycloak/readme.md">this readme</a> for details about Keycloak installation for QSEoK

