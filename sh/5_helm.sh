echo 'executing "5_helm.sh" ...'
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
# according to Qlik Help, helm version must be <2.15
# https://help.qlik.com/en-US/sense-admin/November2019/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/Common/system-requirements-qseok.htm
./get_helm.sh --version v2.14.3

#Initialize Helm Tiller pod, upgrade and update the repos
helm init
helm init --wait --upgrade
helm repo update


