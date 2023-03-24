variable "name" {
  type = string
}

variable "asume_role_json_route" {
  type = string
}

variable "managed_policies_arns" {
  type = list(string)
}


resource "aws_iam_role" "ecs_instance_role" {
  name = var.name
  #! Quien puede asumir este role? En este ejemplo, las EC2
  assume_role_policy = file(var.asume_role_json_route)

  #! Que politicas va a tener. Default de amazon o creados
  managed_policy_arns = var.managed_policies_arns

  tags = {
    Name = var.name
  }
}

output "arn" {
  value = aws_iam_role.ecs_instance_role.arn
}

