echo 'executing "5_helm.sh" ...'
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
#./get_helm.sh --version v2.13.1
./get_helm.sh --version v2.16.1

#Initialize Helm Tiller pod, upgrade and update the repos
helm init
helm init --wait --upgrade
helm repo update


