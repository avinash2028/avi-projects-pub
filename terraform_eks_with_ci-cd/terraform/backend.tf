
terraform {
  backend "s3" {
    bucket         = "dev-terraform-sandbox"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}