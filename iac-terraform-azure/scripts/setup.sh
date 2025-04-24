#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="terraform-azure-lab"
BRANCH_NAME="feature/terraform-azure-lab"
REMOTE_ORG="NickTheDevOpsGuy"

if [[ "${1:-}" == "create-repo" ]]; then
  gh repo create "$REMOTE_ORG/$REPO_NAME" --public --confirm
fi

mkdir -p infrastructure

cat <<EOF > infrastructure/main.tf
provider "azurerm" {
  features {}
}
EOF

cat <<EOF > infrastructure/variables.tf
variable "environment" {
  description = "The deployment environment"
  type        = string
}
EOF

cat <<EOF > .gitignore
.terraform/
*.tfstate
.env
EOF

git init
git remote add origin "git@github.com:$REMOTE_ORG/$REPO_NAME.git"
git checkout -b "$BRANCH_NAME"
git add .
git commit -m "🚀 Initial commit for Terraform Azure Lab"
git push -u origin "$BRANCH_NAME"