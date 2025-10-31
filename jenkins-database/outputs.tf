output "volume_id" {
  description = "ID of the Jenkins EBS volume"
  value       = aws_ebs_volume.jenkins_data.id
}