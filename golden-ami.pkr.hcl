packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "golden-ami"
  instance_type = "t3.micro"
  region        = "us-east-1"
  ssh_username  = "ec2-user"
  source_ami    = "ami-05c13eab67c5d8861" # Amazon Linux 2023 AMI (64-bit (x86)) us-east-1
}

build {
  name    = "build-ami"
  sources = ["source.amazon-ebs.amazon-linux"]

  provisioner "shell" {
    inline = [
        "aws --version",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo yum install -y git",
      "sudo yum install -y amazon-cloudwatch-agent",
      "sudo systemctl enable amazon-cloudwatch-agent",
      "sudo yum install amazon-ssm-agent -y",
      "sudo systemctl enable amazon-ssm-agent",
    ]
  }
}