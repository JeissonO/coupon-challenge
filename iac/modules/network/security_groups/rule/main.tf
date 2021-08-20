resource "aws_security_group_rule" "rule_cidr" {
  count             = var.source_sg_id == "false" && var.protocol != "all" ? 1 : 0
  type              = "ingress"
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = "tcp"
  security_group_id = var.sg_id
  cidr_blocks       = var.cidr_blocks_ingress
  description       = "Ingress ${var.description_rule}"
}
resource "aws_security_group_rule" "rule_cidr_all" {
  count             = var.source_sg_id == "false" && var.protocol == "all" ? 1 : 0
  type              = "ingress"
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  security_group_id = var.sg_id
  cidr_blocks       = var.cidr_blocks_ingress
  description       = "Ingress ${var.description_rule}"
}
resource "aws_security_group_rule" "rule_sg" {
  count                    = var.source_sg_id != "false" && var.protocol != "all" ? 1 : 0
  type                     = "ingress"
  from_port                = var.from_port
  to_port                  = var.to_port
  protocol                 = "tcp"
  security_group_id        = var.sg_id
  source_security_group_id = var.source_sg_id
  description              = "Ingress ${var.description_rule}"
}
resource "aws_security_group_rule" "rule_sg_all" {
  count                    = var.source_sg_id != "false" && var.protocol == "all" ? 1 : 0
  type                     = "ingress"
  protocol                 = var.protocol
  from_port                = var.from_port
  to_port                  = var.to_port
  security_group_id        = var.sg_id
  source_security_group_id = var.source_sg_id
  description              = "Ingress ${var.description_rule}"
}
