locals {

    source_base_url = "/home/esparta86/personal-development/terragrunt-aws-eks/terragrunt-aws-eks/modules/ecr-repository"
    # env_vars        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))

    aws_account_id   = local.account_vars.locals.aws_account_id
    assume_role_name = local.account_vars.locals.assume_role_name
    profile          = local.account_vars.locals.profile
    aws_region       = local.region_vars.locals.aws_region
    

}

