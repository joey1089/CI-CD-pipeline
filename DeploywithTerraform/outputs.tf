#----------- root/outputs.tf ------------------


# output "s3_bucket_uri" {
#   description = "S3 bucket URI"
#   value       = "s3://${aws_s3_bucket.s3-bucket-jenkins-artifacts.id}"
    #Error- References in depends_on must be to a whole object (resource, etc), not to an attribute of an object.
# }

# output "s3_bucket_url" {
#   description = "S3 Bucket URL"
#   value = "https://${aws_s3_bucket.s3-bucket-jenkins-artifacts.id}"
# }

output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

