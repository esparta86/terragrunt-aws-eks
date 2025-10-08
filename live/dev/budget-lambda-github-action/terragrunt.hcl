terraform {
    source ="../../..//modules/budget-lambda-github-action"
}

include "provider_aws" {
    path = find_in_parent_folders("include/provider_aws.hcl")
}

inputs = {


}
