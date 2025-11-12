terraform {
  backend "s3" {
    bucket         = "netscore-terraform-state-bramlak-dorka"
    key            = "frontend-deployment/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "netscore-terraform-locks"
    encrypt        = true
  }
}