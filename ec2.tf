resource "aws_instance" "my_ec2" {
  count                = var.number
  ami                  = "ami-0f8d11b05c3603f7c" # Golden AMI
  instance_type        = "t3.micro"              # you can change this
  key_name             = "centos"                # the name of your public key
  security_groups      = ["foko-sg"]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = "web"
  }

  root_block_device {
    volume_size = var.stockage # you can change this value
  }

  provisioner "file" {
    source      = "./memory_metrics.json"
    destination = "/home/ec2-user/config.json"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./centos.pem") # the public key must be in the same folder as ec2.tf
    host        = self.public_ip

  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/",
      "sudo systemctl restart amazon-cloudwatch-agent"
    ]
  }
}
