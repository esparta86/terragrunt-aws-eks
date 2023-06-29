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