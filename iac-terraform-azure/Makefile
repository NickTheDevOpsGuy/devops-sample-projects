# ----------------------------
# 🛠️ Terraform DevOps Makefile
# ----------------------------

# Initialize Terraform
init:
	terraform init

# Format Terraform code
fmt:
	terraform fmt -recursive

# Validate Terraform files
validate:
	terraform validate

# Run TFLint for linting checks
lint:
	tflint

# Run tfsec for security scanning
sec:
	tfsec .

# Run Terraform plan and save to tfplan.json
plan:
	terraform plan -out=tfplan
	terraform show -json tfplan > tfplan.json

# Apply the plan
apply:
	terraform apply -auto-approve

# Destroy all resources
destroy:
	terraform destroy -auto-approve

# Clean up Terraform junk
cleanup:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan tfplan.json

# Generate terraform-docs
docs:
	terraform-docs markdown table infrastructure/ > infrastructure/README.md
	terraform-docs markdown table modules/network > modules/network/README.md
	terraform-docs markdown table modules/aks > modules/aks/README.md
	terraform-docs markdown table modules/storage > modules/storage/README.md