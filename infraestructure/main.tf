module "vpc" {
  source = "./modules/vpc"
  name   = "hello-world-vpc"
  cidr_block = "10.123.0.0/16"
  public_subnet_cidrs  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnet_cidrs = ["10.123.3.0/24", "10.123.4.0/24"]
  azs = ["sa-east-1a"]
}

module "security_group" {
  source = "./modules/sg"
  name   = "hello-world-sg"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}


module "ecs" {
  source = "./modules/ecs"
  cluster_name      = "hello-world-cluster"
  task_family       = "hello-world-task"
  container_definitions = file("container_definitions.json")
  # 256 (.25 vCPU)
  cpu               = "256"
  # Memory used by task MiB
  memory            = "512"
  execution_role_arn = module.iam_role.iam_role_arn
  task_role_arn      = module.iam_role.iam_role_arn
  service_name       = "hello-world-service"
  # Instances of the task to place and keep running
  desired_count      = 1
  subnets            = module.vpc.public_subnets
  security_groups    = [ module.security_group.security_group_id]
}

module "rds" {
  source = "./modules/rds"
  db_identifier = "rds"
  engine        = "mariadb"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_name       = "mydatabase"
  username      = "admin"
  password      = "password123"
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name = "my-db-subnet-group"
  subnets = module.vpc.private_subnets
}

module "iam_role" {
  source = "./modules/iam"
  role_name = "ecs-task-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      }
    }
  ]
}
EOF
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
