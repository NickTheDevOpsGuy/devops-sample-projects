# 🌐 Terraform Azure Lab

This project sets up a basic Infrastructure as Code (IaC) Terraform environment for Azure.

## 📦 Structure

```
terraform-azure-lab/
├── infrastructure/         # Main Terraform files
├── modules/                # Modularized Terraform components
├── env/                    # Environment variable templates
├── scripts/                # Setup and utility scripts
├── .github/workflows/      # GitHub Actions CI
├── .gitignore              # Git ignored files
└── README.md               # This file
```

## 🚀 Quick Start

```bash
./scripts/setup.sh create-repo
cd terraform-azure-lab
cp env/.env.example .env
source .env
terraform init
terraform plan
terraform apply
```

## 🔄 Cleanup

```bash
./scripts/cleanup.sh
```

## 🛠️ GitHub Actions CI

Runs on pull requests:
- terraform fmt -check
- terraform init
- terraform validate