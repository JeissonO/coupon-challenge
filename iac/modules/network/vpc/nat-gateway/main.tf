resource "aws_eip" "eip" {
  vpc  = true
  tags = merge({ Name = "${var.environment}_${var.project}_nat_eip" }, local.common_tags, )
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(var.public_subnet_ids, 0)
  tags          = merge({ Name = "${var.environment}_${var.project}_nat" }, local.common_tags, )
}
resource "aws_route" "private_route" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
