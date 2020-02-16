resource "aws_vpc" "emr" {
  cidr_block = "10.0.0.0/16"
  tags = var.tags
}
resource "aws_subnet" "emr" {
  vpc_id = aws_vpc.emr.id
  cidr_block = "10.0.1.0/24"
  tags = var.tags
}
