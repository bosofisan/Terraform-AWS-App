# Terraform AWS Infrastructure

Production-ready Infrastructure-as-Code for deploying scalable web applications on AWS with automated CI/CD.

## Overview

This project provisions a complete AWS infrastructure stack using Terraform, including compute, networking, and security resources. It demonstrates infrastructure automation, modular design, and GitOps practices.

## Architecture
```
┌─────────────────────────────────────────┐
│              AWS Cloud                   │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │            VPC                      │ │
│  │  ┌──────────────────────────────┐  │ │
│  │  │     Public Subnet            │  │ │
│  │  │  ┌────────────────────────┐  │  │ │
│  │  │  │   EC2 Instance         │  │  │ │
│  │  │  │   (Application)        │  │  │ │
│  │  │  └────────────────────────┘  │  │ │
│  │  └──────────────────────────────┘  │ │
│  │                                     │ │
│  │  Security Groups │ IAM Roles       │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Features

- **Modular Terraform Configuration** - Clean separation of variables, main logic, and outputs
- **Automated Provisioning** - Complete infrastructure deployed with `terraform apply`
- **Security Best Practices** - IAM roles, security groups, least-privilege access
- **CI/CD Integration** - GitHub Actions workflow for automated deployments
- **User Data Bootstrap** - Automated application setup on EC2 launch

## Infrastructure Components

- **Compute**: EC2 instance with auto-configured application
- **Networking**: VPC, subnets, internet gateway, route tables
- **Security**: Security groups, IAM roles and policies
- **Automation**: User data scripts for application bootstrapping

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

## Quick Start

1. **Clone the repository**
```bash
   git clone https://github.com/bosofisan/Terraform-AWS-App.git
   cd Terraform-AWS-App
```

2. **Initialize Terraform**
```bash
   terraform init
```

3. **Review the plan**
```bash
   terraform plan
```

4. **Apply the configuration**
```bash
   terraform apply
```

5. **Get outputs**
```bash
   terraform output
```

## Configuration

Key variables can be customized in `variables.tf`:

- `region` - AWS region for deployment
- `instance_type` - EC2 instance size
- `ami` - Amazon Machine Image ID
- Additional networking and security settings

## CI/CD Pipeline

GitHub Actions workflow automatically:
- Validates Terraform syntax
- Runs security scans
- Plans infrastructure changes
- Applies changes on merge to main

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Project Structure
```
.
├── main.tf           # Core infrastructure definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── user-data.sh      # EC2 bootstrap script
└── .github/
    └── workflows/    # CI/CD pipelines
```

## Security Considerations

- All resources follow AWS security best practices
- IAM roles use least-privilege principle
- Security groups limit access to required ports only
- Secrets managed via environment variables (never committed)

## Future Enhancements

- [ ] Add RDS database module
- [ ] Implement multi-AZ deployment
- [ ] Add CloudWatch monitoring and alerts
- [ ] Integrate with Application Load Balancer
- [ ] Add auto-scaling groups

## License

MIT

## Contact

For questions or collaboration: boluosofisan@gmail.com
