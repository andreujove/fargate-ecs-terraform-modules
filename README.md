# Fargate ECS with Terraform in modules

This repository contains Terraform configurations for deploying a containerized Flask application on AWS ECS Fargate. It's a refactor repository of this repository: https://github.com/andreujove/fargate-ecs-terraform

## 📋 Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured (aws-cli/2.4.18)
- [Docker](https://www.docker.com/) installed (Docker version 28.1.1, build 4eba377)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed (v1.14.5)
- An AWS account with appropriate permissions

## 🚀 Getting Started

### 1. Configure AWS Profile

Create and configure an AWS profile for this project:

```bash
aws configure --profile tp-exam
export AWS_PROFILE=tp-exam
aws sts get-caller-identity --profile tp-exam
```

### 2. Start Terraform:
```bash
terraform init
```

### 3. Create ECR:
```bash
cd environments/dev/us-east-2
terraform plan -target=aws_ecr_repository.ecr_repository -var-file="dev.tfvars"
terraform apply -target=aws_ecr_repository.ecr_repository -var-file="dev.tfvars"
```

### 4. Login & push the image to ECR:
```bash
export AWS_ACCOUNT_ID=***********
aws ecr get-login-password --region eu-west-2 --profile tp-exam | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com
docker images
docker tag flask-hello:1.0.0 ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/tp-flask-app:1.0.0
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/tp-flask-app:1.0.0
```

### 5. Apply all other resources:
```bash
terraform apply -var-file="dev.tfvars"
```

#### Working with the repository:
```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
terraform destroy -var-file="dev.tfvars"
```

#### Useful command:
```bash
terraform fmt
terraform validate
terraform show
terraform refresh
terraform output
```


References:
- https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html
- https://medium.com/@neamulkabiremon/build-a-production-grade-aws-ecs-fargate-cluster-with-terraform-modular-scalable-ci-cd-ready-07b0c5d40e6f
- https://alexhladun.medium.com/create-a-vpc-endpoint-for-ecr-with-terraform-and-save-nat-gateway-1bc254c1f42
- https://medium.com/@olayinkasamuel44/using-terraform-and-fargate-to-create-amazons-ecs-e3308c1b9166
- https://dev.to/aws-builders/deploying-a-simple-app-on-ecs-with-fargate-terraform-using-community-modules-e0b