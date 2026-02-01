# -------------------------------
# Provider Configuration
# -------------------------------
provider "aws" {
  region = "ap-south-1"   # Change to your preferred region
}

# -------------------------------
# Security Group
# -------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id   # Reference your VPC

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "ec2-sg"
  }
}

# -------------------------------
# EC2 Instance
# -------------------------------
resource "aws_instance" "my_ec2" {
  ami           = "ami-0532be01f26a3de55"
  instance_type = "m7i-flex.large"
  subnet_id     = aws_subnet.public_subnet.id   # Reference your subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Attach existing key pair (best practice)
  key_name = "terrafrom-k8-key"   # Replace with your actual key pair name

  # Root volume configuration
  root_block_device {
    volume_size = 30
    volume_type = "gp3"   # General Purpose SSD (recommended)
    delete_on_termination = true
  }

  tags = {
    Name = "my-ec2-instance"
  }
}

# -------------------------------
# Outputs
# -------------------------------
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "instance_id" {
  value = aws_instance.my_ec2.id
}
