resource "aws_iam_role" "jenkins" {
  name               = "jenkins-ec2-role"
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


resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "terraform_s3" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "terraform_dynamodb" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}




resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins.name
}


data "aws_subnet" "jenkins" {
  id = var.ec2_private_subnet_id
}


resource "aws_security_group" "jenkins_ec2" {
  name        = "jenkins-ec2-sg"
  description = "Security group for jenkins isntance"
  vpc_id      = data.aws_subnet.jenkins.vpc_id

  ingress {
    description     = "Jenkins web ui port"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Jenkins instance ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}






data "aws_ami" "amazon_linux_64" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  owners = ["amazon"]
}




resource "aws_instance" "jenkins" {
  ami                  = data.aws_ami.amazon_linux_64.id
  instance_type        = var.instance_type
  subnet_id            = var.ec2_private_subnet_id
  iam_instance_profile = aws_iam_instance_profile.jenkins.name
  security_groups      = [aws_security_group.jenkins_ec2.id]
  key_name             = var.key_name

  root_block_device {
    volume_size = var.instance_root_size
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install wget -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf upgrade -y
    sudo dnf install -y java-21-amazon-corretto
    sudo dnf install jenkins -y
    sudo dnf install git -y
    
    sudo dnf install -y amazon-ssm-agent
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    

    DEVICE=$(readlink -f /dev/sdf)
    if ! lsblk -f "$DEVICE" | grep -q ext4; then
      sudo mkfs -t ext4 "$DEVICE"
    fi

    sudo usermod -aG docker jenkins

    sudo mkdir -p /var/lib/jenkins
    sudo mount /dev/sdf /var/lib/jenkins
    sudo chown -R jenkins:jenkins /var/lib/jenkins

    sudo systemctl start jenkins
    sudo systemctl enable jenkins
  EOF


  tags = {
    Name = "${var.project_name}-jenkins"
  }
}

resource "aws_volume_attachment" "jenkins_data_attach" {
  device_name = "/dev/sdf"
  volume_id   = var.ebs_volume_id
  instance_id = aws_instance.jenkins.id
}