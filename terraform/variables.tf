variable "aws_region" {
  default = "ap-northeast-3"
}

variable "key_name" {
  description = "Name of EC2 key pair"
}

variable "my_ip" {
  description = "Your public IP in CIDR, example: 122.161.66.110/32"
}

variable "instance_type" {
  default = "t3.micro"
}
