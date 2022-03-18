locals {
  backend_path = "terraform-states-${get_aws_account_id()}"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "remote_state_override.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region         = get_env("AWS_DEFAULT_REGION")
    bucket         = local.backend_path
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    dynamodb_table = local.backend_path
  }
}

generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${get_env("AWS_DEFAULT_REGION")}"
}
EOF
}

inputs = {
  vars = {
    source_location = get_env("SOURCE_LOCATION")
  }
}
