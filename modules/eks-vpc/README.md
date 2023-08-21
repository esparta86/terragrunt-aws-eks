# eks-vpc


> Command to test access to EKS





## How to use it

1. SETUP your config file in aws

`
[personal]
region = us-east-1
aws_account_id = ##########
output = json



[profile personal-####]
role_arn = arn:aws:iam::#####:role/{ROLE_USED_TO_CREATE_THE_CLUSTER}
source_profile = personal
region = us-east-1
`

2. return details about the iam user or role whose credentials are used to call the operation

 - ` $ $ aws --profile personal-xxxx sts get-caller-identity `

3. Update kubeconfig local

` $ aws eks update-kubeconfig --name {CLUSTER_NAME} --region {REGION} --alias {CLUSTER_NAME} --profile personal-#### `

NOW, you are able to retrieves resources from EKS

` $ kb get nodes
NAME                         STATUS   ROLES    AGE   VERSION
ip-10-0-1-173.ec2.internal   Ready    <none>   26m   v1.25.9-eks-0a21954
ip-10-0-2-115.ec2.internal   Ready    <none>   25m   v1.25.9-eks-0a21954
`


## Setup Container Insights EKS

By default EKS doesn't perform the configuration to collect logs
from de apps and send it to CloudWatch
You can read this aws documentation https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html#Container-Insights-FluentBit-setup to know more about how
it works.

In our eks-vpc module, I created the following resource to achieve this.

| RESOURCE AWS                          | Description |
| -------------                         | ------------- |
|  aws_iam_role -> iam-role-fluent-bit  | creates an IAM role with a trust policy that allows the Fluent Bit service in an EKS cluster to assume the role based on specific conditions defined in the OIDC token. This role can be used to grant necessary permissions to Fluent Bit for performing its tasks within the EKS cluster.                 |
| aws_iam_policy -> policy_sa_logs | policy in aws that is going to use by the previous role in order to have permisssions to send logs to CloudWatch  |



1. Go to enabling-cloudwatch directory
   You will find a yaml file that has some resources that is going to install into EKS
   there are 2 service accounts
   one of these is going to use a role defined in Terraform





----------------------- INSTALL CERT MANAGER ------

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.12.0 --debug --timeout 15m0s


----------------------- INSTALL ARC ACTION RUNNER CONTROLLER -------------------------------------

# Create a Personal Access Token in Github
PAT : <GitHub Token>

# Creating Namespace for ARC
kubectl create ns actions-runner-system

# Creating secret for ARC, so that it can register runners on github
kubectl create secret generic controller-manager -n actions-runner-system
--from-literal=github_token=<GitHub Token>



└$ helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller

└$ helm search repo actions-runner-controller --versions

└$ helm upgrade --install --namespace actions-runner-system --create-namespace --wait actions-runner-controller actions-runner-controller/actions-runner-controller --version 0.20.0 --timeout=15m0s





