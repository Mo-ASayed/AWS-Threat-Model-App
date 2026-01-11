resource "twingate_remote_network" "aws_network" {
  name = "AWS Network"
}

resource "twingate_connector" "aws_connector" {
  remote_network_id = twingate_remote_network.aws_network.id
}

resource "twingate_connector_tokens" "aws_connector_tokens" {
  connector_id = twingate_connector.aws_connector.id
}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


module "twingate_connector" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6"

  name          = "tm-twingate-connector"
  ami           = data.aws_ami.latest.id
  instance_type = "t2a.micro"

  # Use existing VPC subnet and security group
  subnet_id              = module.vpc.public_subnets[0] # pick a subnet with internet access
  vpc_security_group_ids = [module.security_group.sg_id]

  # user_data to configure Twingate
  user_data = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.twingate_network}.twingate.com"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT

  root_block_device = [
    {
      encrypted = true
    }
  ]
}


# 1️⃣ Create the Twingate resource
resource "twingate_resource" "tm_app" {
  name              = "TM App"
  address           = module.alb.alb_dns_name
  remote_network_id = twingate_remote_network.aws_network.id

  access_group {
    group_id = twingate_group.admins.id
  }
}

resource "twingate_group" "admins" {
  name = "Admin"
}
