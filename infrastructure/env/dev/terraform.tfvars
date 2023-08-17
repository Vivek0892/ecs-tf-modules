# common settings
aws_region = "us-east-1"
stack = "cloud-bootstrap"
aws_profile = "default"
image_repo_name = "cloud-bootstrap"
source_repo_name = "cloud-bootstrap"
image_repo_url = "533332969751.dkr.ecr.us-east-1.amazonaws.com/cloud-bootstrap"
source_repo_branch = "main"
# stage-specific settings
# DEV stage
fargate-task-service-role-dev = "cloud-bootstrap-role-dev"
vpc_cidr_dev = "172.20.0.0/16"
az_count_dev = "2"