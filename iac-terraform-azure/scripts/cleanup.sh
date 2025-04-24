#!/usr/bin/env bash
set -euo pipefail

terraform destroy -auto-approve || true
rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup