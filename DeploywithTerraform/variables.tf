#------------- root/variables.tf ---------------------

variable "ami" {
  default = "ami-0715c1897453cabd1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ssh_key_name" {
  default = "key-pair-jens"
}

variable "ec2_user_data" {
  description = "User data script for EC2"
  type        = string
  default     = "user-data.sh"
}

variable "ec2_tag" {
  default = "jenkins-01"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_tag" {
  default = "custom-vpc"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "subnet_tag" {
  default = "custom-subnet"
}

variable "internet_gateway_tag" {
  default = "custom-igw"
}

variable "ec2_role_name" {
  default = "ec2_role"
}

variable "ec2_instance_profile_name" {
  default = "ec2_instance_profile"
}

variable "ec2_role_policy_name" {
  default = "ec2_role_policy"
}

variable "ec2-trust-policy" {
  default = "trust-policy.json"
}

variable "ec2-s3-permissions" {
  default = "s3-permissions.json"
}

variable "bucket_name" {
  default = "custom-s3-bucket-4-jenkins-artifacts"
}

variable "security_group_name" {
  default = "security-group-SG"
}

