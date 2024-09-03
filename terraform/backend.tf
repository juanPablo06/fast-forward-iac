terraform {
  backend "s3" {
    bucket = "terraform-backend-ue1"
    key    = "ft/terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "terraform-state-lock"
  }
}
