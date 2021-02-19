provider "aws" {
  profile = "penny"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket  = "cost-penny-membercur-bucket-<account id>"
    key     = "statefile/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = "true"
    profile = "penny"
  }
}

