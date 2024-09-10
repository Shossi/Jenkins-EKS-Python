resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip

  tags = merge(var.tags, { Name = var.instance_name })

  user_data = var.user_data
}
