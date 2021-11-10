resource "aws_security_group_rule" "webapp_ingress_443" {
  type              = "ingress"
  security_group_id = aws_security_group.webapp.id

  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/32"] 

}

resource "aws_security_group_rule" "webapp_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.webapp.id

  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

}
