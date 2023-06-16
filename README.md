# terragrunt-aws-eks


> A brief description of this repository

This repository has modules of Terraform and diferrent environments 
So the purpose is to learn and apply best practices when a company
has many environments and a lot of infrastructure as code (iac)
one of these is implement a terrgaunt that is wrapper that is going to help 
us to avoid copy/paste terraform code and keep configurations DRY

## Directories

- [live](live)  Here, you can define multiples environment as you want, each environment is going to have sub folders
                each subfolder represents a module that the environment needs.
                inside a module will there a terragrunt.hcl

- [modules](modules) Here, you can define the modules using Terraform



## How to use it

1. Update the file [terragrunt.hcl](live/terragrunt.hcl)
   Update the backend config according the resources that you are going to use with AWS

2. Go to live/dev/vpc and execute the terragrunt code

 ` $ terragrunt init `
 ` $ terragrunt plan `
 ` $ terragrunt  apply `
