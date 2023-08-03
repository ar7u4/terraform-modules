provider "aws" {
  region = var.region
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr, 0, 24 * (each.index - 1))

  tags {
    Name = "public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr, 16, 24 * (each.index - 1))

  tags {
    Name = "private-subnet-${each.key}"
  }
}

module "nat_gateway" {
  source = "hashicorp/aws/modules/nat_gateway"

  vpc_id = aws_vpc.main.vpc_id
  subnet_id = aws_subnet.public[0].id
}

module "internet_gateway" {
  source = "hashicorp/aws/modules/internet_gateway"

  vpc_id = aws_vpc.main.vpc_id
}

module "nacl" {
  source = "hashicorp/aws/modules/network_acl"

  vpc_id = aws_vpc.main.vpc_id
  name = "${var.vpc_name}-nacl"

  ingress_rules = [
    {
      protocol = "tcp"
      port_range = "80-80"
      source_cidr_block = "0.0.0.0/0"
    },
  ]

  egress_rules = [
    {
      protocol = "tcp"
      port_range = "0-65535"
      destination_cidr_block = "0.0.0.0/0"
    },
  ]
}
