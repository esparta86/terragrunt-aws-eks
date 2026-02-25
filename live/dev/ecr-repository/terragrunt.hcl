include "root" {
    path = find_in_parent_folders("root.hcl")
}

include "provider_aws" {
    path = find_in_parent_folders("include/provider_aws.hcl")
}

include "ecr" {
    path   = find_in_parent_folders("include/ecr.hcl")
    expose = true
}


terraform {
    source = include.ecr.locals.source_base_url
}


inputs = {
    ecr_map = [
        {
            name = "nonprd_1"
            image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
            exclusion_filter = [
                {
                    filter="dev-*"
                    filter_type="WILDCARD"
                }
            ]
        },
        {
            name = "prd_2"
            image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"
            exclusion_filter = [
                {
                    filter="prod-*"
                    filter_type="WILDCARD"
                }
            ]
        }        
    ]
}
