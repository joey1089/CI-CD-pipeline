#----------- root/outputs.tf ------------------


output "s3_bucket_uri" {
  description = "S3 bucket URI"
  value       = "s3://${aws_s3_bucket.s3.id}"
}

output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

