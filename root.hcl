

locals {
  parsed =  regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir())
  env = local.parsed.env

}

remote_state {
    backend = "s3"

    config = {
        bucket = "BUCKET_NAME"
        region = "us-east-1"
        key    =  "${path_relative_to_include()}/terraform.tfstate"
        dynamodb_table = "terraform-locks"
        encrypt = true
        profile = "PROFILE_AWS"
    }

    generate = {
      path = "backend.tf"
      if_exists = "overwrite_terragrunt"
    }
}
