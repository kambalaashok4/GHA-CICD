# GHA-CICD

A Django application deployed to **AWS ECS (Fargate)** via **GitHub Actions** CI/CD and **Terraform** infrastructure-as-code.

## Architecture

```
GitHub Push → GitHub Actions → Build & Test → Scan-Sonar-scaner → Push image to ECR → Terraform Apply → ECS Fargate
```

**AWS Resources provisioned by Terraform:**
- **VPC** with 2 public subnets across AZs
- **Amazon ECR** — Docker image registry
- **Amazon ECS (Fargate)** — serverless container runtime
- **Application Load Balancer** — routes HTTP traffic to containers
- **CloudWatch Logs** — centralised container logging
- **SSM Parameter Store** — stores the Django secret key
- **IAM Roles** — least-privilege execution and task roles

## Repository Structure

```
├── .github/workflows/deploy.yml  # CI/CD pipeline
├── app/                          # Django application
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── manage.py
│   ├── myproject/                # Django project (settings, urls, wsgi)
│   └── myapp/                    # Django app (views, urls, tests)
└── terraform/                    # Infrastructure as Code
    ├── main.tf       # Provider & backend configuration
    ├── variables.tf  # Input variables
    ├── outputs.tf    # Output values
    ├── vpc.tf        # VPC, subnets, security groups
    ├── ecr.tf        # ECR repository
    ├── iam.tf        # IAM roles and policies
    ├── alb.tf        # Application Load Balancer
    └── ecs.tf        # ECS cluster, task definition, service, SSM
```

## GitHub Actions Workflow

| Trigger | Jobs run |
|---|---|
| Push to `main` | Test → Build & push Docker image → Terraform apply |
| Pull Request to `main` | Test + Terraform plan (no apply) |

## Setup Instructions

### 1. AWS Prerequisites

1. Create an **S3 bucket** for Terraform state (with versioning enabled).
2. Create an **IAM user** with the following managed policies:
   - `AmazonEC2FullAccess`
   - `AmazonECS_FullAccess`
   - `AmazonEC2ContainerRegistryFullAccess`
   - `AmazonSSMFullAccess`
   - `IAMFullAccess`
   - `AmazonS3FullAccess` (for Terraform state bucket)
3. Generate **Access Key / Secret Key** for that IAM user.

### 2. GitHub Repository Secrets

Navigate to **Settings → Secrets and variables → Actions** and add:

| Secret name | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key |
| `TF_STATE_BUCKET` | Name of S3 bucket used for Terraform state |
| `DJANGO_SECRET_KEY` | A strong random string for Django's SECRET_KEY |

### 3. First-time Infrastructure Bootstrap

Before the GitHub Actions pipeline can run `terraform apply`, the ECR repository must exist so Docker images can be pushed. Bootstrap with:

```bash
cd terraform
terraform init \
  -backend-config="bucket=<your-tf-state-bucket>" \
  -backend-config="key=django-ecs/terraform.tfstate" \
  -backend-config="region=us-east-1"

terraform apply \
  -var="django_secret_key=<your-secret-key>"
```

### 4. Deploy

Push to `main` — the GitHub Actions workflow will automatically:
1. Run Django unit tests
2. Build and push the Docker image to ECR (tagged with the short commit SHA)
3. Run `terraform apply` to update the ECS task definition with the new image tag

### 5. Access the Application

After deployment, find the ALB DNS name in the Terraform outputs:
```bash
terraform output alb_dns_name
```

Then open `http://<alb-dns-name>/` in your browser.

Health check endpoint: `http://<alb-dns-name>/health/`

## Local Development

```bash
cd app
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## Running Tests Locally

```bash
cd app
python manage.py test --verbosity=2
```
