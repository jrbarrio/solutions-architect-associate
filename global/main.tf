provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "jrb.terraform.state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}