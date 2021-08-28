resource "aws_instance" "rbc_ubuntu_Server" {
  count                  = 2
  ami                    = var.ubuntuami
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.rbc_sg.id]
  subnet_id              = element(aws_subnet.subnets.*.id, count.index)
  key_name               = var.key_name

  tags = {
    Name = "Ubuntu_Server_${count.index + 1}"
    Type = "Docker"
  }

}
# 2 Instance Of Redhat Servers(t2.micro)
resource "aws_instance" "rbc_redhat_servers" {
  count                  = 2
  ami                    = var.redhatami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.rbc_sg.id]
  subnet_id              = element(aws_subnet.subnets.*.id, count.index)
  key_name               = var.key_name
  user_data              = file("init_script.sh")
  tags = {
    Name = "Redhat_Server_${count.index + 1}"
  }

}
