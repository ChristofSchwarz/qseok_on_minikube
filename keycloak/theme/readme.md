# Custom theme

The easiest way is to mount a new folder into /opt/jboss/keycloak/themes/
of the pod. This new folder is then shown as a selectable theme in the Admin console of keycloak. 
I am mounting the folder /theme (this one you are in right now) using hostPath and mountPath in 
<a href="../keycloak-depl-persist.yaml">keycloak-depl-persist.yaml</a>



