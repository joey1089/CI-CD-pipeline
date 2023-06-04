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

variable "user_data_ubuntu" {
  description = "User data script for EC2 Ubuntu 22.04 LTS"
  type        = string
  default     = <<EOF
                  #!/bin/bash
                  # Install Java and then Jenkins
                  apt update && apt upgrade -y
                  apt install openjdk-11-jdk -y
                  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
                    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
                  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                    https://pkg.jenkins.io/debian-stable binary/ | tee \
                    /etc/apt/sources.list.d/jenkins.list > /dev/null
                  apt-get update
                  apt-get install jenkins
                  systemctl enable jenkins
                  systemctl start jenkins
                  EOF
}

variable "user_data" {
  description = "User data script for EC2 Amazon Linux"
  type        = string
  default     = <<EOF
                        #!/bin/bash
                        # Install Jenkins and Java 
                        sudo wget -O /etc/yum.repos.d/jenkins.repo \
                            https://pkg.jenkins.io/redhat-stable/jenkins.repo
                        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
                        sudo yum upgrade -y
                        # Add required dependencies for the jenkins package
                        sudo amazon-linux-extras install -y java-openjdk11 
                        sudo yum install -y jenkins
                        sudo systemctl daemon-reload

                        # Start Jenkins
                        sudo systemctl enable jenkins
                        sudo systemctl start jenkins

                        # Firewall Rules
                        if [[ $(firewall-cmd --state) = 'running' ]]; then
                            YOURPORT=8080
                            PERM="--permanent"
                            SERV="$PERM --service=jenkins"

                            firewall-cmd $PERM --new-service=jenkins
                            firewall-cmd $SERV --set-short="Jenkins ports"
                            firewall-cmd $SERV --set-description="Jenkins port exceptions"
                            firewall-cmd $SERV --add-port=$YOURPORT/tcp
                            firewall-cmd $PERM --add-service=jenkins
                            firewall-cmd --zone=public --add-service=http --permanent
                            firewall-cmd --reload
                        fi
                  EOF
}

variable "ec2_tag" {
  default = "Amazon-Jenkins-Server"
}

variable "ubuntu_ec2_tag" {
  default = "Ubuntu-Jenkins-Server"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc_tag" {
  default = "custom-vpc"
}

variable "subnet_cidr" {
  default = "10.10.0.0/24"
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

variable "amazon_instance_profile_name" {
  default = "amazon_instance_profile"
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

# variable "bucket_name" {
#   default = "s3-bucket-jenkins-artifacts"
# }

variable "environment" {
  default = "Testing"
}

variable "security_group_name" {
  default = "security-group-SG"
}

