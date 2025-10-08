

helm upgrade --install --namespace actions-runner-system \
  --create-namespace --wait actions-runner-controller \
  actions-runner-controller/actions-runner-controller \
  --set syncPeriod=1m


  kubectl create secret generic controller-manager -n actions-runner-system --from-literal=github_token=PERSONAL_TOKEN

  export NAMESPACE="arc-systems"
  helm install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set authSecret.create=true \
    --set authSecret.github_token="PERSONAL_TOKEN" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \
    --wait --set syncPeriod=1m 

==
helm upgrade arc  --namespace "${NAMESPACE}" --create-namespace \
  --set authSecret.create=true     --set authSecret.github_token="PERSONAL_TOKEN" \
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \
  --wait --set syncPeriod=1m --debug --dry-run --install

--------
output:
> 
Pulled: ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller:0.11.0
Digest: sha256:35003eb7db8bba6dbf4f3df1d637959d938f7a8d7fad5640de9b5f5f834e1b0b
NAME: arc
LAST DEPLOYED: Tue Apr 29 11:30:19 2025
NAMESPACE: arc-systems
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing gha-runner-scale-set-controller.

Your release is named arc.




    export INSTALLATION_NAME="arc-runner-set" \
    export RUNNERS_NAMESPACE="arc-runners" \
    export GITHUB_CONFIG_URL="https://github.com/esparta86/pet-clinic-project"    

    
    helm install ${INSTALLATION_NAME} \
    --namespace "${RUNNERS_NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="PERSONAL_TOKEN" \
    --set minRunners=1 \
    --set maxRunners=10 \
    --set controllerServiceAccount.namespace=arc-systems \
    --set controllerServiceAccount.name=arc-gha-rs-controller \
    --set template.spec.serviceAccountName=sa.esparta86-nonprd \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
    --set
    --debug \
    --wait \
    --dry-run
