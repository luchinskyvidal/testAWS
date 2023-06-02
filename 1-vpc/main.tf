provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

    tags = {
    Name = "mi-vpc"
  }
}

resource "aws_subnet" "public_subnet_zone_1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.aws_region_zone_1

    tags = {
    Name = "public_subnet_zone_1"
  }
}

resource "aws_subnet" "app_subnet_zone_1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.aws_region_zone_1

    tags = {
    Name = "app_subnet_zone_1"
  }
}

resource "aws_subnet" "data_subnet_zone_1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.aws_region_zone_1

    tags = {
    Name = "data_subnet_zone_1"
  }
}

resource "aws_subnet" "public_subnet_zone_2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.aws_region_zone_2

    tags = {
    Name = "public_subnet_zone_2"
  }
}

resource "aws_subnet" "app_subnet_zone_2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.aws_region_zone_2

    tags = {
    Name = "app_subnet_zone_2"
  }
}

resource "aws_subnet" "data_subnet_zone_2" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = var.aws_region_zone_2

    tags = {
    Name = "data_subnet_zone_2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_test.id

    tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_test.id

    tags = {
    Name = "public_route_table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association_zone_1" {
  subnet_id      = aws_subnet.public_subnet_zone_1.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_association_zone_2" {
  subnet_id      = aws_subnet.public_subnet_zone_2.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_lb" "application_load_balancer" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_zone_1.id,
    aws_subnet.public_subnet_zone_2.id
  ]

  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_test.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc_test.id

  ingress {
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
}

resource "aws_route53_zone" "example_zone" {
  name = var.aws_dominio
}

resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = var.aws_dominio
  type    = "A"
  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}
