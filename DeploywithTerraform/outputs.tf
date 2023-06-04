#----------- root/outputs.tf ------------------

output "ec2_remote_access" {
  description = "EC2 Remote Access"
  value       = "ssh -i ${local_file.private_key_pem.filename} ec2-user@${aws_instance.amazon_instance.public_ip}"
}

output "instance_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = "Jenkins Server Public IP: ${aws_instance.amazon_instance.public_ip}"
}

output "s3_bucket_uri" {
  description = "S3 bucket URI"
  value       = "S3 Bucket URI: s3://${aws_s3_bucket.s3_bucket.id}"
}

#
# output "s3_bucket_uri" {
#   description = "S3 bucket URI"
#   value       = "s3://${aws_s3_bucket.s3-bucket-jenkins-artifacts.id}"
#Error- References in depends_on must be to a whole object (resource, etc), not to an attribute of an object.
# }

# output "s3_bucket_url" {
#   description = "S3 Bucket URL"
#   value = "https://${aws_s3_bucket.s3-bucket-jenkins-artifacts.id}"
# }

output "ubuntu-test-server_public_ip" {
  value = aws_instance.ubuntu-instance.public_ip
}

