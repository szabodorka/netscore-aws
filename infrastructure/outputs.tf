output "vpn_s3_config_paths" {
  description = "List of S3 paths for each client's VPN config file"
  value = module.vpn.s3_config_paths
}

output "jenkins_instance_id" {
  description = "Id of the Jenkins ec2 instance"
  value = module.jenkins.instance_id
}

output "jenkins_private_ip" {
  value = module.jenkins.private_ip
  description = "Private IPv4 address of the Jenkins EC2 instance"
}

output "jenkins_web_ui_url" {
  description = "Url of jenkins web ui"
  value = module.jenkins.web_ui_url
}