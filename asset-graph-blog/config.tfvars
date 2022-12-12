
# Misc
env_tag       = "cloud-devops"

# VPC Configuration
vpc_name      = "cloud-devops-vpc"
vpc_cidr      = "10.0.0.0/21"
az_1          = "us-west-2a"
az_2          = "us-west-2b"
private_sub_1 = "10.0.1.0/24"
private_sub_2 = "10.0.2.0/24"
public_sub_1  = "10.0.3.0/24"
public_sub_2  = "10.0.4.0/24"
enable_nat    = true

#  EC2 Configuration
instance_type      = "m5.large" # Must be Nitro
shared_volume_size = 30
