# Qlik Sense Enterprise on Minikube

Status: 05-Oct-2019

*Note:* This is a newer version of repository <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision">qs_on_Kubernetes</a>. The video about installing it https://youtu.be/dhQowB_Q9xU is still acurate to the point that this one already installs Qlik Sense Enterprise on Kubernetes and it uses port 443 (https) instead of 32443. 

The container-creation for all pods of qliksense deployment takes **quite some time**, on slower networks like 60-90 minutes.

Check if all pods are ready with command
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

**Info:** Keycloak is an open source software product to allow single sign-on with Identity Management and Access Management aimed at modern applications and services. As of March 2018 this JBoss community project is under the stewardship of Red Hat who use it as the upstream project for their RH-SSO product.[1] From a conceptual perspective the tool's intent is to make it easy to secure applications and services with little to no coding.

Go to <a href="keycloak">keycloak</a> folder for more ...


