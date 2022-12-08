resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

resource "aws_ebs_volume" "shared_volume" {
  multi_attach_enabled = true
  availability_zone    = var.az_1
  size                 = var.shared_volume_size
  type                 = "io1"

  tags = {
    Name = var.env_tag
  }
}

resource "aws_instance" "instance" {
  count           = 3
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = module.vpc.subnet_id[0]
  instance_type   = var.instance_type
  security_groups = [aws_security_group.security_group.name]

  tags = {
    Name = "${var.env_tag}-instance"
  }
}
