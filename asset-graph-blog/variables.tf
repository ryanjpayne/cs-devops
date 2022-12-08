# Misc
variable "env_tag" {
  type = string
}

# Vpc Configuration
variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "az_1" {
  type = string
}
variable "az_2" {
  type = string
}
variable "private_sub_1" {
  type = string
}
variable "private_sub_2" {
  type = string
}
variable "public_sub_1" {
  type = string
}
variable "public_sub_2" {
  type = string
}
variable "enable_nat" {
  type = bool
}

# EC2 Configuration
variable "shared_volume_size" {
  type = number
}
variable "instance_type" {
  type = string
}