resource "aws_eip" "nat" {
  vpc = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = [var.az_1, var.az_2]
  private_subnets = [var.private_sub_1, var.private_sub_2]
  public_subnets  = [var.public_sub_1, var.public_sub_2]

  enable_nat_gateway  = var.enable_nat
  single_nat_gateway  = true
  reuse_nat_ips       = true
  external_nat_ip_ids = [aws_eip.nat.id]
  tags = {
    Environment = var.env_tag
  }
}

resource "aws_security_group" "security_group" {
  name        = "cloud-devops-sg"
  description = "Manage traffic for cloud-devops instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "All within VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Environment = var.env_tag
  }
}
