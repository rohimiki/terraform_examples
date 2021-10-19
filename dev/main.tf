terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/16"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "s-pcc"
    workspaces = {
      name = "PROJECT-DEV"
    }
  }
}
