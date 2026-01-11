terraform {
  // requires updating - maybe look into rennovate bot or something similar
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
    twingate = {
      source  = "Twingate/twingate"
      version = "3.7.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = "ssltd"

}
