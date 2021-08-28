resource "aws_security_group" "rbc_sg" {
  name        = "allow_all_ports"
  description = "Allow All inbound traffic"
  vpc_id      = aws_vpc.rbcvpc.id

  ingress {
    description      = "All ports from all protocol"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_traffic"
  }
}
