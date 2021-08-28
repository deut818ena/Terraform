provider "aws"{
region = "us-east-1"

}
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

#creating a subnet
resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub"
  }
}
#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
   }

  tags = {
    Name = "RT"
  }
}

#Route table assoc
resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.sub.id
  route_table_id = aws_route_table.RT.id
}
#Create security group

resource "aws_security_group" "SG" {
  name        = "Allow_web_traffic"
  description = "Allow All inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  

  ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    #  ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

  ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
     # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }


  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow_tls"
  }
}
#create Elastic IP
resource "aws_eip" "my-eip" {
  instance = aws_instance.web.id
  vpc      = true
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}

#Create network Interface

resource "aws_network_interface" "NI" {
  subnet_id       = aws_subnet.sub.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.SG.id]

}

#Create instance
resource "aws_instance" "web" {
  ami           = "ami-0747bdcabd34c712a" # us-west-2
  instance_type = "t2.micro"
key_name = "obose1"
  network_interface {
    network_interface_id = aws_network_interface.NI.id
    device_index = 0
  }

  user_data = <<-E0F
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first webserver > /var/www/html/index.html'
                E0F
}
