terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "local" {
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "172.19.0.0/21"
}

resource "aws_vpc_dhcp_options" "dhcp" {
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

output "vpc_dhcp_options_in_terraform_state" {
    value = aws_vpc.vpc.dhcp_options_id
}

output "vpc_dhcp_options_in_aws" {
    value = aws_vpc_dhcp_options.dhcp.id
}