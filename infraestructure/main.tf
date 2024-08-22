# Template Container
data "template_file" "container_definitions" {
  template = file("${path.module}/templates/container_definitions.json.j2")

  vars = {
    container_name  = "ballenita_minera"
    container_image = "adminer"
    memory          = "512"
    cpu             = "256"
    # db_port         = "3306"
    # db_name         = "cgstest"
    # db_user         = "admin"
    # db_password     = "@@01@@02@@03/"
  }
}

module "vpc" {
  source = "./modules/vpc"
  name   = "hello-world-vpc"
  cidr_block = "10.123.0.0/16"
  # Cambiar nomrbres de subnets
  public_subnet_cidrs  = ["10.123.1.0/24" ] #, "10.123.2.0/24"]
  private_subnet_cidrs = ["10.123.3.0/24" , "10.123.4.0/24"]
  azs = ["sa-east-1a", "sa-east-1b"]
}

module "security_group" {
  source = "./modules/sg-http"
  name   = "hello-world-http-sg"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}
module "security_group_mysql" {
  source = "./modules/sg-mysql"
  name   = "hello-world-db-sg"
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}

module "ecs" {
  source = "./modules/ecs"
  cluster_name      = "hello-world-cluster"
  task_family       = "hello-world-task"
  container_definitions = data.template_file.container_definitions.rendered
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
  db_name       = "cgstest"
  username      = "admin"
  password      = "clavesuperSEGURA"
  vpc_security_group_ids = [ module.security_group_mysql.security_group_id ]
  db_subnet_group_name = "my-db-subnet-group"
  subnets =  module.vpc.private_subnets
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
