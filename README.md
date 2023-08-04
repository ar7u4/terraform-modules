# terraform-modules
#VPC Terraform module with variables


The Terraform script will create the following things:

A VPC with the specified CIDR block.
Two subnets in each availability zone: one public subnet and one private subnet.
A NAT gateway in one of the public subnets.
An internet gateway attached to the VPC.
A network ACL for the VPC.
The script will also tag all of the resources with the specified VPC name.

Here is a breakdown of what each of the resources does:

VPC: A VPC is a virtual private cloud. It is a logical isolation of your AWS resources.
Subnet: A subnet is a logical division of a VPC. Subnets can be used to group resources together and to control access to those resources.
NAT gateway: A NAT gateway is a network address translation (NAT) gateway. NAT gateways allow instances in private subnets to access the internet.
Internet gateway: An internet gateway is a gateway that allows your VPC to communicate with the internet.
Network ACL: A network ACL is a set of rules that control network traffic in and out of a VPC.
