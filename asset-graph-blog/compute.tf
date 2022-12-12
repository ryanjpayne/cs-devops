resource "aws_iam_instance_profile" "test_profile" {
  name = "cs_test_profile"
  role = aws_iam_role.role.name
}

resource "aws_ebs_volume" "shared_volume" {
  multi_attach_enabled = true
  availability_zone    = var.az_1
  size                 = var.shared_volume_size
  type                 = "io1"
  iops                 = 1000

  tags = {
    Name = var.env_tag
  }
}

resource "aws_instance" "instance" {
  count           = 3
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = module.vpc.private_subnets[0]
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = "${var.env_tag}-instance"
  }
}

resource "aws_volume_attachment" "ebs_att_0" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.shared_volume.id
  instance_id = aws_instance.instance[0].id
}

resource "aws_volume_attachment" "ebs_att_1" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.shared_volume.id
  instance_id = aws_instance.instance[1].id
}

resource "aws_volume_attachment" "ebs_att_2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.shared_volume.id
  instance_id = aws_instance.instance[2].id
}
