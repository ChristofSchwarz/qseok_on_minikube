# Qlik Sense Enterprise on Minikube

Status: 17-Oct-2019

*Note:* This is a newer version of my repo <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision">qs_on_Kubernetes</a>. I made a separate video showing how to install this https://youtu.be/_QfyxV4gpeM

 ## How to provision 

We will install an Ubuntu Linux. For that you will need 

 - A license from Qlik that is enabled for Multi-Cloud
 - Oracle VirtualBox 5.2 or later from https://www.virtualbox.org/ or an alternative hypervisor
 - Vagrant 2.2 or later from https://www.vagrantup.com/ <br/>(Note if prompted where to install leave the default C:\HarshiCorp\Vagrant to avoid issues later !)

After you downloaded (and unzipped) this git, open a Command Prompt and navigate to this folder. We start based on a Ubuntu Xenial base box and then provision what is stated in the <a href="Vagrantfile">Vagrantfile</a> file and the /sh subfolder
``` 
vagrant up
```
wait 1.5 hour or so for all the packages to deploy. To get a terminal window type
```
vagrant ssh
```
Type "exit" to get back from bash of the Ubuntu into your host system prompt.

If you want to stop and remove the VM properly (also if you want to restart the provisioning process), type
```
vagrant destroy
```

 ## Configuration

You can see <a href="Vagrantfile">here the settings</a> for this virtual machine. It uses 
 * Ubuntu 16.04
 * 6 GB RAM
 * 2 processors
 * sets root user to __vagrant__ password __vagrant__

The container-creation for all pods of qliksense deployment takes **quite some time**, on slower networks like 60-90 minutes.

Check if all pods are ready with command
```
kubectl get pods
```
This installation first starts using Qlik's built-in simple OIDC, so you don't need an Identity Provider. If you don't switch to keycloak (see further below), then you must set your hosts file on the computer, where you will browse to QSEoK in order to resolve "elastic.example". On Windows, the hosts file is under C:\Windows\System32\drivers\etc\hosts and must be edited as Admin.
```
192.168.56.234 elastic.example
```
 * then connect to https://elastic.example , accept the warning of the self-signed certificate, you will be taken to a simple login-page with 10 hard-coded users described here https://support.qlik.com/articles/000076585
 
 * alternatively, which i recommend, you can install and switch to Keycloak (no hosts file change needed), where you can also setup users as needed in the Keycloak web admin console. Read on ...

## using Keycloak as IDP for QSEoK

**Info:** Keycloak is an open source software product to allow single sign-on with Identity Management and Access Management, maintained by JBoss community project and under the stewardship of Red Hat. The tool's intent is to make it easy to secure applications and services with little to no coding.

Go to <a href="keycloak">keycloak</a> folder for more ...


