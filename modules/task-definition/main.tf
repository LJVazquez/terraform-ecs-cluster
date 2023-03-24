variable "family" {
  type    = string
  default = "terra-task-def"
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "network_mode" {
  type    = string
  default = "bridge"
}

variable "container_cpu" {
  type    = number
  default = 0
}

variable "container_name" {
  type = string
}

variable "image" {
  type = string
}

variable "ports" {
  type        = map(any)
  description = "containerPort, hostPort, protocol, appProtocol"
}

resource "aws_ecs_task_definition" "task_def" {
  family = var.family

  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode

  #TODO crear role IAM
  #! sin este permiso, la tarea no tiene permisos esenciales como descargar imagenes
  task_role_arn      = "arn:aws:iam::681508469066:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::681508469066:role/ecsTaskExecutionRole"

  #! Con ruta relativa no lo toma
  container_definitions = file("/modules/task-definition/container-definitions.json")
  # container_definitions = jsonencode([
  #   {
  #     essential = true
  #     name      = var.container_name
  #     image     = var.image
  #     cpu       = var.container_cpu
  #     portMappings = [
  #       {
  #         name          = "${var.container_name}-${var.ports["containerPort"]}-${var.ports["protocol"]}",
  #         containerPort = var.ports["containerPort"],
  #         hostPort      = var.ports["hostPort"],
  #         protocol      = var.ports["protocol"]
  #         appProtocol   = var.ports["appProtocol"]
  #       }
  #     ]
  #   }
  # ])
}

output "arn" {
  value = aws_ecs_task_definition.task_def.arn
}


