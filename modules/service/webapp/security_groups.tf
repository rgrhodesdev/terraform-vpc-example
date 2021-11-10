resource "aws_security_group" "webapp" {
  name        = "${var.environment}-Web-App"
  description = "Web App Security Groups"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "${var.environment}-Web-App"
  }
}