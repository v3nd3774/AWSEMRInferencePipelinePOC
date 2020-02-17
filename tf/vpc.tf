locals {
  vpc_cidr = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
}
resource "aws_vpc" "emr" {
  enable_dns_support = true
  enable_dns_hostnames = true
  cidr_block = local.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  tags = var.tags
}
resource "aws_internet_gateway" "emr" {
  vpc_id = aws_vpc.emr.id
  tags = var.tags
}
resource "aws_egress_only_internet_gateway" "emr" {
  vpc_id = aws_vpc.emr.id
}
resource "aws_route_table" "emr" {
  vpc_id = aws_vpc.emr.id
  tags = var.tags
}
resource "aws_route" "incoming" {
  route_table_id = aws_route_table.emr.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.emr.id
}
resource "aws_route" "outgoing" {
  route_table_id = aws_route_table.emr.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id = aws_egress_only_internet_gateway.emr.id
}
resource "aws_route_table_association" "emr" {
  subnet_id = aws_subnet.emr.id
  route_table_id = aws_route_table.emr.id
}
resource "aws_subnet" "emr" {
  vpc_id = aws_vpc.emr.id
  cidr_block = local.subnet_cidr
  tags = var.tags
}
