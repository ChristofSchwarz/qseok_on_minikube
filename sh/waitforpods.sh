# Christof Schwarz: Only works with bash, not with sh
# wait until all containers of all pods are running

function fnWaitForPods() {
  local period interval n statuses
  if [[ $# != 2 ]]; then
    echo "Usage: waitforpods.sh [PERIOD] [INTERVAL]" 
    echo "this script waits until all pods are ready." 
    return -1
  fi

  period="$1"
  interval="$2"
  echo "Checking for all pods to be 'Running', $period seconds max ..."  

  for ((n=0; n<$period; n+=$interval)); do
    statuses="$(kubectl get pod -o json|jq -r '.items[].status.containerStatuses[].state'|grep -v 'running'|grep -v 'startedAt'|grep -v '{'|grep -v '}')" || true
    if [[ $statuses == "" ]]; then
      kubectl get pods
      echo "All pods are running"
      return 1
    fi
    echo "Not all pods are are running, found the following statuses:"
    echo "$statuses"
    kubectl get pods | grep -v Running
    echo "Waiting $interval seconds ..."
    sleep $interval
  done 
  echo "Waited for $period seconds but still not all the pods are ready ..."
  return 0
}

fnWaitForPods $@
