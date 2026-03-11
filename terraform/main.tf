terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # All backend configuration is supplied at runtime via -backend-config flags.
    # See the README and the GitHub Actions workflow for details.
    # Example:
    #   terraform init \
    #     -backend-config="bucket=<your-tf-state-bucket>" \
    #     -backend-config="key=django-ecs/terraform.tfstate" \
    #     -backend-config="region=us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}
