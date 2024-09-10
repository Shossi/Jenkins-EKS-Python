resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  security_groups    = var.load_balancer_type == "application" ? var.security_groups : null
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, { Name = var.lb_name })
}

# Create Target Group (for ALB or NLB)
resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = merge(var.tags, { Name = var.target_group_name })
}

resource "aws_lb_target_group_attachment" "this" {
  for_each         = var.targets
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value.id
  port             = each.value.port
}

# Create Listener (for ALB or NLB)
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  depends_on = [aws_lb.this]
}
