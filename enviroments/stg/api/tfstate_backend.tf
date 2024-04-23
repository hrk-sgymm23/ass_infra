terraform {
  backend "s3" {
    bucket  = "ass-tfstate-bucket"
    key     = "api/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}