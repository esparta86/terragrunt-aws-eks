
----------------------- INSTALL CERT MANAGER ------

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.12.0 --debug --timeout 15m0s


----------------------- INSTALL ARC ACTION RUNNER CONTROLLER -------------------------------------
https://blog.opstree.com/2023/04/18/github-self-hosted-runner-on-kubernetes/


# Create a Personal Access Token in Github
PAT : <GitHub Token>

# Creating Namespace for ARC
kubectl create ns actions-runner-system

# Creating secret for ARC, so that it can register runners on github
kubectl create secret generic controller-manager -n actions-runner-system
--from-literal=github_token=<GitHub Token>


`└$ helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller`

`└$ helm search repo actions-runner-controller --versions`

`└$ helm upgrade --install --namespace actions-runner-system --create-namespace --wait actions-runner-controller actions-runner-controller/actions-runner-controller --version 0.20.0 --timeout=15m0s `


# Create a runner deployment

specify the repository that you want that use the new worker
      repository: esparta86/terraform-practice-exercises

` kubectl apply -f runner.yaml `

# Create a workflow

copy and paste the content

