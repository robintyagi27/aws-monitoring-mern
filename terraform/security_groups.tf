# ----------------------------------------------
# Web Server Security Group
# ----------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # SSH only from anywhere (assignment only - best to restrict later)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP public
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS public
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus only from your IP
  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "web-sg"
    Project = "aws-monitoring-mern"
  }
}

# ----------------------------------------------
# Database Security Group (Private Subnet MongoDB)
# ----------------------------------------------

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for MongoDB server"
  vpc_id      = aws_vpc.main.id

  # Allow SSH only from Web Server
  ingress {
    description     = "SSH from Web Server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # MongoDB access only from Web Server SG
  ingress {
    description     = "MongoDB Access"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "db-sg"
    Project = "aws-monitoring-mern"
  }
}
