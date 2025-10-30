output "instance_id" {
  description = "Id of the Jenkins ec2 instance"
  value = aws_instance.jenkins.id
}

output "private_ip" {
  value = aws_instance.jenkins.private_ip
  description = "Private IPv4 address of the Jenkins EC2 instance"
}