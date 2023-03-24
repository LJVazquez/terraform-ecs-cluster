variable "name" {
  description = "Name of the SG"
  default     = "terra-sg"
}

variable "description" {
  description = "Description of the SG"
  default     = "terra security group"
}

variable "ingress_from" {
  type = number
}

variable "ingress_to" {
  type = number
}

variable "ingress_protocol" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "egress_from" {
  type = number
}

variable "egress_to" {
  type = number
}

variable "egress_protocol" {
  type = string
}

variable "egress_cidr_blocks" {
  type = list(string)
}


variable "vpc_id" {
  description = "vpc id"
}

resource "aws_security_group" "security_group" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress_from
    to_port     = var.ingress_to
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = var.ingress_from
    to_port     = var.ingress_to
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  tags = {
    Name = "terra ${var.name}"
  }
}

output "id" {
  value = aws_security_group.security_group.id
}
