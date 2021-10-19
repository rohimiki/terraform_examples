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
    organization = "example_corp"
    workspaces = {
      name = "PROJECT-DEV"
    }
  }
}

resource "aws_subnet" "main" {
  # Terraform 0.12 and later: use the "outputs.<OUTPUT NAME>" attribute
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
}
