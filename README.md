# AWS ECS Deployment Project

This project deploys a Pomodoro timer app to AWS using ECS Fargate.

The infrastructure is provisioned with Terraform and includes a custom VPC, 2 public subnets, 2 private subnets, NAT gateway, internet gateway, an application load balancer, HTTPS using ACM, Route 53 DNS, ECR to store Docker images, and ECS Fargate for running the app.

CI/CD is implemented using GitHub Actions with OIDC authentication to AWS. 

Images are built and tagged with the Git commit SHA before being pushed to ECR via the 'application' pipeline.

Separate Terraform pipelines deploy and destroy the infrastructure.

## Architecture Diagram

![architecture diagram](ecs-images/architecture.png)


## App Demo

Here you can see the app is publicly visible on https://pomodoro.mohammedislam.uk

![HTTPS demo](ecs-images/working-https.png)

Manual health check, by running

```bash
curl -i https://pomodoro.mohammedislam.uk/health
```

![health check](ecs-images/health_check.png)

## Local Setup

1. Clone this repo

```bash
git clone https://github.com/mohammed-972/terraform-ecs-pomodoro
cd terraform-ecs-pomodoro
```

2. Build Docker image

```bash
docker build -t pomodoro-app ./app
```

3. Run container

```bash
docker run -p 8080:8080 pomodoro-app
```

4. View app

Open: http://localhost:8080

5. Health check

Run the following command

```bash
curl -i http://localhost:8080/health
```


## Bootstrap / First Deployment

Initially or after the entire infrastructure is destroyed, the ECR repository must be recreated before the application pipeline can push a Docker image.

From the `infra/` directory:

```bash
terraform init
terraform apply -target=module.ecr
```

## Project Structure

```
terraform-ecs-pomodoro
├── app/...
│   ├── css/
│   ├── js/
│   ├── Dockerfile
│   ├── index.html
│   └── nginx.conf
├── infra/
│   ├── backend.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── route53.tf
│   ├── variables.tf
│   └── module/
│       ├── acm/
│       ├── alb/
│       ├── ecr/
│       ├── ecs/
│       ├── iam/
│       ├── security_groups/
│       └── vpc/
├── .github/
│   └── workflows/
│       ├── application.yml
│       ├── terraform-deploy.yml
│       └── terraform-destroy.yml
├── ecs-images/
└── README.md
```

## Application Pipeline

![application pipeline](ecs-images/application_pipeline.png)

The Application Pipeline can be triggered manually or automatically when files inside the `app/` directory are changed and pushed to the `main` branch.

The pipeline authenticates to AWS using OIDC, logs in to Amazon ECR, builds the Docker image, tags it with the Git commit SHA, and pushes the image to the ECR repository.


## Deploy Pipeline

![deploy pipeline](ecs-images/deploy_pipeline.png)

The Deploy Pipeline is triggered manually using GitHub Actions.

When starting the workflow, an ECR image tag must be provided. The image tag is the Git commit SHA used by the Application Pipeline when the image was pushed to ECR.

The pipeline authenticates to AWS using OIDC, sets up Terraform, initialises the S3 remote backend, validates the Terraform configuration, creates a Terraform plan using the selected image tag, and applies that saved plan.


## Destroy Pipeline

![destroy pipeline](ecs-images/destroy_pipeline.png)

This pipeline is triggered manually using Github actions. The pipeline authenticates to AWS, initialises Terraform and destroys the Terraform infrastructure.