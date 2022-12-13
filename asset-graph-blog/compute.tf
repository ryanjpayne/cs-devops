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
  key_name        = var.key_pair
  ami             = data.aws_ami.amazon-2.id
  subnet_id       = module.vpc.private_subnets[0]
  instance_type   = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data = <<EOF
#!/bin/bash
yum install jq -y
yum update -y
cd /tmp
export FALCON_CID=${var.cid}
export FALCON_CLOUD_API=${var.falcon_cloud_api}
export TOKEN=$(curl \
--silent \
--header "Content-Type: application/x-www-form-urlencoded" \
--data "client_id=${var.client_id}&client_secret=${var.client_secret}" \
--request POST \
--url "https://$FALCON_CLOUD_API/oauth2/token" | \
jq -r '.access_token')
export INSTALLER_ID=$(curl -X GET "https://api.crowdstrike.com/sensors/combined/installers/v1?limit=1&filter=os%3A%22Amazon%20Linux%22" \
-H  "accept: application/json" \
-H "authorization: Bearer $TOKEN" | jq -r '.resources[0].sha256')
curl -X GET "https://api.crowdstrike.com/sensors/entities/download-installer/v1?id=$INSTALLER_ID" \
-H  "accept: application/json" \
-H  "authorization: Bearer $TOKEN" \
-o falcon_installer.rpm
yum install -y falcon_installer.rpm
/opt/CrowdStrike/falconctl -s --cid=$FALCON_CID
systemctl start falcon-sensor
EOF

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
