#---------- root/main.tf -----------

# Custom VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_tag
  }
}

# Public Subnet
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_tag
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway_tag
  }
}

# Route Table
resource "aws_default_route_table" "default_route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

# Public IP and add to Security Group
data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

# Security Group
resource "aws_security_group" "jenkins_security_group" {
  name_prefix = var.security_group_name
  description = "Jenkins EC2 instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH from my Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Access to the Jenkins Server"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Access to the Jenkins Server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Jenkins_Security_Group"
  }
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy
resource "aws_iam_policy" "ec2_role_policy" {
  name = var.ec2_role_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_role_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.ec2_instance_profile_name
  role = aws_iam_role.ec2_role.name
}

# Create SSH Keys for EC2 Remote Access
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.generated.private_key_pem
  filename        = "${var.ssh_key_name}.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "generated" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.generated.public_key_openssh
}

# EC2 Instance - AMI -Amazon # Linux
resource "aws_instance" "ec2_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  security_groups      = [aws_security_group.jenkins_security_group.id]
  subnet_id            = aws_subnet.subnet_public.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = var.user_data
  tags = {
    Name = var.ec2_tag
  }
}

# EC2 Instance - Ubuntu -Ubuntu, 22.04 LTS
resource "aws_instance" "ubuntu-instance" {
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t3.small"
  key_name        = var.ssh_key_name
  security_groups = [aws_security_group.jenkins_security_group.id]
  subnet_id       = aws_subnet.subnet_public_ubuntu.id
  tags = {
    Name = "Ubuntu-Jenkins-Test-Server"
  }


}

# subnet public
resource "aws_subnet" "subnet_public_ubuntu" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_public_ubuntu"
  }

}

# S3 Buckets
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 Bucket ACL
# resource "aws_s3_bucket_acl" "jenkinsbucketacl" {
#   bucket = var.bucket_name
#   acl    = "private"
#   depends_on = [aws_s3_bucket_ownership_controls.aws_s3_bucket.s3_bucket_acl_ownership]
# #   depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
# }