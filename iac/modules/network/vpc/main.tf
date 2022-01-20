/*VPC de la solucion*/
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge({ Name = "${var.environment}_${var.project}_vpc" }, local.common_tags, )
}
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id     = aws_vpc.main.id
  tags       = merge({ Name = "${var.environment}_${var.project}_ig" }, local.common_tags, )
  depends_on = [aws_vpc.main]
}
/* Subnet Publica*/
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.vpc_azs, count.index)
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "${var.environment}_${var.project}_${element(var.vpc_azs, count.index)}_public_subnet" }, local.common_tags, )
}
/* Subnet Privada*/
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.vpc_azs, count.index)
  map_public_ip_on_launch = false
  tags                    = merge({ Name = "${var.environment}_${var.project}_${element(var.vpc_azs, count.index)}_private_subnet" }, local.common_tags, )
}
// RouteTable Privada
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.main.id
  tags       = merge({ Name = "${var.environment}_${var.project}_private_route_table" }, local.common_tags, )
  depends_on = [aws_vpc.main]
}
/* RouteTable Default*/
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags       = merge({ Name = "${var.environment}_${var.project}_default_route_table" }, local.common_tags, )
  depends_on = [aws_internet_gateway.ig]
}
/* RouteTable Publica*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags       = merge({ Name = "${var.environment}_${var.project}_public_route_table" }, local.common_tags, )
  depends_on = [aws_vpc.main]
  lifecycle {
    ignore_changes = [route]
  }
}
/* Association Publica*/
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
/* Association Privada*/
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
/* ACL Privada*/
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private.*.id
  egress {
    protocol   = "all"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = merge({ Name = "${var.environment}_${var.project}_private_acl" }, local.common_tags, )
}
