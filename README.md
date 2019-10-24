# Qlik Sense Enterprise on Minikube

Status: 24-Oct-2019

*Note:* This is a newer version of my repo <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision">qs_on_Kubernetes</a>. I made a separate video showing how to install this https://youtu.be/_QfyxV4gpeM 
 * It automatically installs and sets a local **Keycloak** installation as your identity provider for Qlik Sense
 * Keycloak console at http://192.168.56.234:32080/auth), login with admin / admin
 * It waits for qlik sense deployment to finish (all pods are ready), will connect via API and even set the site license 

 ## How to provision 

We will install an Ubuntu 16 Linux. For that you will need 

 - A license from Qlik that is enabled for Multi-Cloud
 - Oracle VirtualBox 5.2 or later from https://www.virtualbox.org/ or an alternative hypervisor
 - Vagrant 2.2 or later from https://www.vagrantup.com/ <br/>(Note if prompted where to install leave the default C:\HarshiCorp\Vagrant to avoid issues later !)

After you downloaded (and unzipped) this git, open a Command Prompt and navigate to this folder. We start based on a Ubuntu Xenial base box and then provision what is stated in the <a href="Vagrantfile">Vagrantfile</a> file and the /sh subfolder
``` 
vagrant up
```
This takes up to 2 hours to finish. It deploys keycloak and waits for the qliksense deployment to finish, even the license will be set which you can provide as a text file in the folder /yaml/sitelicense.txt. 

To bash into your new Ubuntu box you simply can use 
```
vagrant ssh
```
however, I recommend to use <a href="https://www.putty.org">Putty</a>

If you want to stop and remove the VM properly (also before you want to restart the provisioning process), run
```
vagrant destroy
```

 ## Configuration

You can see <a href="Vagrantfile">here the settings</a> for this virtual machine. It uses 
 * Ubuntu 16.04
 * 6 GB RAM
 * 2 processors
 * sets root user to __vagrant__ password __vagrant__

## using Keycloak as IDP for QSEoK

**Info:** Keycloak is an open source software product to allow single sign-on with Identity Management and Access Management, maintained by JBoss community project and under the stewardship of Red Hat. The tool's intent is to make it easy to secure applications and services with little to no coding.

Go to <a href="keycloak">keycloak</a> folder for more ...


