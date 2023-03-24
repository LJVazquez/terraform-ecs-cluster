variable "name" {
  type    = string
  default = "terra-cluster"
}

variable "autoscaling_group_arn" {
  type = string
}

resource "aws_ecs_cluster" "cluster" {
  name = var.name

  tags = {
    "Name" = var.name
  }
}

resource "aws_ecs_capacity_provider" "cprovider" {
  name = "terra-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.autoscaling_group_arn
  }
}

#* ENLACE ENTRE CLUSTER Y CAPACTIY PROVIDER
resource "aws_ecs_cluster_capacity_providers" "ecs_cprovider_binding" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.cprovider.name]
}

output "id" {
  value = aws_ecs_cluster.cluster.id
}
