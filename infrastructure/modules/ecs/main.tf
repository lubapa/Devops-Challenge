resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  tags = {
    Name = "${var.cluster_name}:csgtest"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = var.task_family
  container_definitions = var.container_definitions
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = var.cpu
  memory                = var.memory
  execution_role_arn    = var.execution_role_arn
  task_role_arn         = var.task_role_arn
}

resource "aws_ecs_service" "app" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  # Instances of the task to place and keep running
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }
  tags = {
    Name = "${var.service_name}:csgtest"
  }
  load_balancer {
    target_group_arn =  var.target_group_arn
    container_name   = var.container_name
    container_port   = 80
  }
}
