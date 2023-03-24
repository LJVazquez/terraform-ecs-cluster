provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id

  ingress_protocol    = "TCP"
  ingress_from        = 0
  ingress_to          = 65535
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_protocol    = "-1"
  egress_from        = 0
  egress_to          = 0
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "autoscaling_group" {
  source              = "./modules/autoscaling-group"
  subnet_ids          = module.vpc.subnet_ids
  security_groups_ids = [module.security_group.id]
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
}

module "ecs_cluster" {
  source                = "./modules/ecs-cluster"
  autoscaling_group_arn = module.autoscaling_group.arn
}

module "task_def" {
  source         = "./modules/task-definition"
  container_name = "nginx-container"
  image          = "nginx:latest"
  ports = {
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
    appProtocol   = "http"
  }
}

module "service" {
  source              = "./modules/ecs-service"
  cluster_id          = module.ecs_cluster.id
  task_definition_arn = module.task_def.arn
}
