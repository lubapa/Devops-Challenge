resource "aws_iam_role" "ecs_task_execution" {
  name               = var.role_name
  # assume_role_policy = jsonencode(var.assume_role_policy)
  assume_role_policy = var.assume_role_policy

  tags = {
    Name = "${var.role_name}:csgtest"
  }
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.ecs_task_execution.id
  # policy = jsonencode(var.policy)
  policy = var.policy
}
