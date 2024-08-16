terraform {
    source = "../../../modules/test"
}


include {
    path = find_in_parent_folders()
}

inputs = {
  environment = "dev"
}