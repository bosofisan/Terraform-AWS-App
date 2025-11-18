# Terraform AWS Infrastructure Project

#### End-to-End AWS Environment Provisioning with CI/CD Automation

This project delivers a full AWS environment built entirely with Terraform, wired into a GitHub Actions CI pipeline, and automatically deploys a lightweight NGINX web application. The goal is to showcase cloud infrastructure provisioning, automation, and production-aligned patterns using Infrastructure-as-Code.

Lightweight, free-tier friendly, and production-pattern aligned. 

## Architecture Overview

```
Developer Push -> GitHub -> Terraform CI -> AWS Infra -> EC2 -> Auto-deployed Web App
``` 

#### AWS Resources Created
- VPC
- Public Subnet
- Internet Gateway
- Route Table + Association
- Security Group
- EC2 Instance 
- NGINX Web Server (via user-data)

## Tech Stack

- Terraform
- AWS (VPC, EC2, SG, IGW)
- GitHub Actions (CI Pipeline)
- NGINX
- Bash (user-data)

## Project Structure

```bash
terraform-aws-app/
├── main.tf
├── variables.tf
├── outputs.tf
├── user-data.sh
└── .github/workflows/ci.yml
```

## Infrastructure Code

```main.tf```
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type          = "t2.micro"              # Free-tier eligible
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("user-data.sh")

  tags = {
    Name = "terraform-web-app"
  }
}
```

#### EC2 Bootstrap Script ```user-data.sh```
```bash
#!/bin/bash
yum update -y

amazon-linux-extras install -y nginx1
systemctl enable nginx
systemctl start nginx

cat <<EOF > /usr/share/nginx/html/index.html
<html>
  <h1>Terraform Deployed This</h1>
  <p>Hi Lulu! Your project is live from AWS EC2.</p>
</html>
EOF
```

#### Outputs```outputs.tf```
```hcl
output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}
```

## GitHub Actions CI Pipelines

```.github/workflows/ci.yml```
```yaml
name: Terraform CI

on:
  push:
    branches: [ "main" ]
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan
```
This pipeline performs: 
- Terraform formatting check
- Terraform validation
- Terraform plan
- Manual apply 

## Deployment Instructions

#### Initialize Terraform
```bash
terraform init
```

#### Validate configuration
```bash
terraform validate
```

#### Preview changes
```bash
terraform plan
```

#### Deploy infrastructure 
```bash
terraform apply
```

#### Get the EC2 public IP
```bash
terraform output ec2_public_ip
```

Visit: 
http://Your_Public_IP

## Result

A fully automated AWS environment with a live web app served from NGINX on an EC2 instance deployed using best-practice IaC and validated through CI

## Why I Built This Project

I created this project to demonstrate real-world DevOps fundamentals: designing cloud infrastructure from scratch, automating deployments, and validating everything through CI. My goal was to show that I can take an application from local code to a fully deployed environment using the same patterns engineering teams use in production.

I specifically chose AWS, Terraform, and GitHub Actions because they represent core tools used across Cloud, DevOps, and Platform Engineering roles. This project allowed me to reinforce key concepts like:
- Infrastructure as Code (repeatable, version-controlled environments)
- Building secure, scalable AWS networking
- Automating server provisioning with user-data
- Validating infrastructure changes with a CI pipeline
- Following production-style workflows (format, validate, plan, apply)

## Troubleshooting

While extending this project to include Kubernetes (EKS), I observed a pod scheduling limitation caused by small EC2 instance types hitting their ENI-based pod density maximum.
I documented analysis and remediation pathways such as:
- enabling prefix delegation
- adjusting instance sizes
- increasing node group capacity

## Author

#### Lulu Osofisan
Cloud|DevOps|Platform Engineering

- GitHub: bosofisan
- AWS, Kubernetes, Terraform projects 