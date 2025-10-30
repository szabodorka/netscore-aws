resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = "gp3"

  tags = {
    Name = "${var.project_name}-jenkins-data"
  }
}
