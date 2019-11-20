if [ -z "$1" ]
  then
    echo "Please supply the .yaml file as argument"
  else
    rm ~/manifests/qliksense/* -r
    helm template --output-dir ~/manifests --name qlik ~/charts/qliksense/ --values $1
    echo '~/manifest folder updated. Next run 'sh applymanifest.sh'
fi
