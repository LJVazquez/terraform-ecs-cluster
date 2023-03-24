variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "security_groups_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "iam_instance_role_arn" {
  type = string
}

resource "aws_launch_template" "launch_template" {
  name        = "terra-launch-template"
  description = "linux 2 ECS template"
  #! AMI que ejecuta cuando se crea un cluster linux 2
  image_id      = "ami-0798aaad33ff8890b"
  instance_type = "t2.micro"

  lifecycle {
    # Para que cree uno nuevo antes de destruir este cuando se hacen cambios
    create_before_destroy = true
  }

  #! rol de instancia que le permite ejecutar cosas necesarias como el servicio ECS
  #TODO AGREGAR IAM
  iam_instance_profile {
    arn = "arn:aws:iam::681508469066:instance-profile/ecsInstanceRole"
  }

  vpc_security_group_ids = var.security_groups_ids

  #! IMPORTANTE: script para que agregue el EC2 al ECS y ejecute el servicio ECS
  #! sin esto el cluster no va a encontrar la instancia
  user_data = base64encode("#!/bin/bash\necho 'ECS_CLUSTER=terra-cluster' > /etc/ecs/ecs.config\nstart ecs")

}

resource "aws_autoscaling_group" "asgroup" {
  name             = "terra-ecs-asg"
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true #si se sale del grupo, se elimina el EC2

  launch_template {
    id = aws_launch_template.launch_template.id
  }

  vpc_zone_identifier = var.subnet_ids

  #! importante agregar el tag AmazonECSManaged si se usa para un ECS
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}


output "arn" {
  description = "Autoscaling group ARN"
  value       = aws_autoscaling_group.asgroup.arn
}

#TODO AGREGAR IAM
