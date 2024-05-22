data "aws_caller_identity" "current" {}

# ECSクラスター
resource "aws_ecs_cluster" "main" {
  name = "${var.common_name}-ecs-cluster-${var.enviroment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS AutoScaling
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECSタスク定義
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.common_name}-task-def-${var.enviroment}"
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  task_role_arn            = module.ecs_task_execution_role.iam_role_arn
  container_definitions = templatefile("${path.module}/task_definitions.tpl.json", {
    service_name              = "${var.common_name}-${var.enviroment}"
    rails_tag                 = var.ecs_rails_tag
    nginx_tag                 = var.ecs_nginx_tag
    rails_ecr_arn             = var.rails_ecr_arn
    nginx_ecr_arn             = var.nginx_ecr_arn
    ssm_db_password_path      = var.ssm_db_password_path
    ssm_db_user_name_path     = var.ssm_db_username_path
    ssm_db_port_path          = var.ssm_db_port_path
    ssm_db_host_path          = var.ssm_db_host_path
    ssm_db_name_path          = var.ssm_db_name_path
    ssm_rails_master_key_path = var.ssm_rails_master_key_path
    enviroment                = var.enviroment
  })
}

# ECS実行ロール＆ポリシー
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy]
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::871107023173:role/ecsTaskExecutionRole"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ecs:ExecuteCommand"]
    resources = ["arn:aws:iam::871107023173:role/ecsTaskExecutionRole"]
  }
}

module "ecs_task_execution_role" {
  source     = "../iam_role"
  name       = "${var.common_name}-ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

# ECS Service
resource "aws_ecs_service" "main" {
  name                              = "${var.common_name}-${var.enviroment}"
  cluster                           = aws_ecs_cluster.main.arn
  task_definition                   = aws_ecs_task_definition.main.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  health_check_grace_period_seconds = 300
  enable_execute_command            = true
  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_security_group.security_group_id]
    subnets          = var.private_subnet_ids
  }
}

module "nginx_security_group" {
  source              = "../sg"
  security_group_name = "${var.common_name}-nginx"
  vpc_id              = var.vpc_id
  port                = 80
  cidr_blocks         = var.cidr_blocks
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.common_name}-${var.enviroment}"
  retention_in_days = 180
}