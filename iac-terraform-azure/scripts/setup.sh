#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
terraform workspace new "$ENVIRONMENT" || terraform workspace select "$ENVIRONMENT"
terraform init
terraform plan -out=tfplan