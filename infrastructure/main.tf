# Container definitions
module "ecs_data" {
  source = "./modules/ecs_data"
  container_image = var.container_image
  container_name = "${var.app_name}-${var.branch_name}"
  aws_secret_pull = var.aws_secret_pull
}

#VPC creation
module "vpc" {
  source = "./modules/vpc"
  name   = "${var.app_name}-vpc-${var.branch_name}"
  cidr_block = "10.124.0.0/16"
  public_subnet_cidrs  = ["10.124.1.0/24", "10.124.2.0/24"]
  private_subnet_cidrs = ["10.124.3.0/24", "10.124.4.0/24"]
  azs = ["sa-east-1a", "sa-east-1b"]
}

# ALB Http security group
module "security_group_alb" {
  source = "./modules/sg-http-alb"
  name   = "${var.app_name}-http-alb-sg-${var.branch_name}"
  # name   = "${var.app_name}-http-alb-sg-${var.branch_name}"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}
# Http security group
module "security_group_ecs" {
  source = "./modules/sg-http"
  name   = "${var.app_name}-ecs-sg-${var.branch_name}"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc, module.security_group_alb]
  security_group_alb_id = module.security_group_alb.security_group_id
}
# mysql security group
module "security_group_mysql" {
  source = "./modules/sg-mysql"
  name   = "${var.app_name}-DB-sg-${var.branch_name}"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
  security_group_ecs_id = module.security_group_ecs.security_group_id
}

# Load Balancer creation
module "alb" {
  source = "./modules/alb"
  name   = "${var.app_name}-alb-${var.branch_name}" 
  # name   = "${var.app_name}-alb-${var.branch_name}" 
  security_groups = [module.security_group_alb.security_group_id, module.security_group_ecs.security_group_id]
  subnets = module.vpc.public_subnet_cidrs
  vpc_id = module.vpc.vpc_id
}

# ECS creation
module "ecs" {
  source = "./modules/ecs"
  cluster_name      = "${var.app_name}-cluster-${var.branch_name}"
  task_family       = "${var.app_name}-task-${var.branch_name}"
  container_definitions = module.ecs_data.container_definitions_rendered
  # 256 (.25 vCPU)
  cpu               = "256"
  # Memory used by task MiB
  memory            = "512"
  execution_role_arn = module.iam_role.iam_role_arn
  task_role_arn      = module.iam_role.iam_role_arn
  service_name       = "${var.app_name}-service-${var.branch_name}"
  # Instances of the task to place and keep running
  desired_count      = 1
  subnets            = module.vpc.private_subnets
  security_groups    = [ module.security_group_ecs.security_group_id]
  load_balancer_arn      = module.alb.alb_arn
  target_group_arn       = module.alb.target_group_arn
  container_name = "${var.app_name}-${var.branch_name}"
}

# RDS service 
module "rds" {
  source = "./modules/rds"
  db_identifier = "${var.app_name}-rds"
  engine        = "mariadb"
  instance_class = "db.t3.micro"
  allocated_storage = 10
  db_name       = "${var.app_name}db"
  username          = var.aws_rds_username
  password          = var.aws_rds_password
  vpc_security_group_ids = [ module.security_group_mysql.security_group_id ]
  db_subnet_group_name = "${var.app_name}-db-subnet-group-${var.branch_name}"
  subnets =  module.vpc.private_subnets
}


#Role for ECS execution task
module "iam_role" {
  source = "./modules/iam"
  role_name = "${var.app_name}-ecs-task-execution-role${var.branch_name}"
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
        "logs:PutLogEvents",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
