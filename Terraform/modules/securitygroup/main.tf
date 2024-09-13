resource "aws_security_group" "sec_group" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      security_groups  = lookup(ingress.value, "security_groups", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", [])
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = var.tags
}
