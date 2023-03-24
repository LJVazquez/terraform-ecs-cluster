variable "name" {
  type    = string
  default = "terra-service"
}

variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

resource "aws_ecs_service" "service" {
  name                    = var.name
  cluster                 = var.cluster_id
  task_definition         = var.task_definition_arn
  desired_count           = var.desired_count
  enable_ecs_managed_tags = true #crea tags en los tasks

  #iam_role        = "arn:aws:iam::681508469066:instance-profile/ecsInstanceRole"
  #depends_on      = [aws_iam_role_policy.foo]

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.foo.arn
  #   container_name   = "mongo"
  #   container_port   = 8080
  # }
}
