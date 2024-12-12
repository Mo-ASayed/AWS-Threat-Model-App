terraform {
  backend "s3" {
    bucket  = "threat-modeling-tool--tf"
    key     = "state"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "Dev"
    Purpose     = "Terraform State Locking"
  }
}