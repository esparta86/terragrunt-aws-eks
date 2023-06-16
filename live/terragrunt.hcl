

locals {
  parsed =  regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir())
  env = local.parsed.env

}

remote_state {
    backend = "s3"

    config = {
        bucket = "terragrunt-aws-colocho86"
        region = "us-east-1"
        key    =  "${path_relative_to_include()}/terraform.tfstate"
        dynamodb_table = "terraform-locks"
        encrypt = true
        profile = "personal"
    }

    generate = {
      path = "backend.tf"
      if_exists = "overwrite_terragrunt"
    }
}