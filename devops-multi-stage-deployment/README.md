# 🚀 DevOps Multi-Stage Deployment (AZ-400 Sample Project)

This project demonstrates a **real-world Azure DevOps multi-stage pipeline** for deploying a containerized FastAPI web app to **three environments**: Dev, Staging, and Production.

## 💡 Key Accomplishments

- 🔧 Built multi-stage pipeline with:
  - ✅ Bicep template validation
  - 🧪 Pytest test execution and coverage enforcement
  - 📈 Test & coverage report publishing
  - 📦 Docker image build and push to ACR
  - 🌐 Deployments to Azure Web Apps (Dev, Staging, Prod)

- 🔐 Secrets managed securely using Azure Key Vault
- 🧼 Pipeline is emoji-powered for clarity and swagger 😎
- 🔍 Smoke tests executed post-deployment for live validation

## 📁 Repository: [`devops-multi-stage-deployment`](https://github.com/NickTheDevOpsGuy/devops-sample-projects/tree/feature/devops-multi-stage-deployments/devops-multi-stage-deployment)

---

## 🧱 Tech Stack

- **App**: FastAPI + Jinja2 (Python 3.11)
- **IaC**: Bicep
- **CI/CD**: Azure DevOps Pipelines
- **Infra**: Azure Web Apps (Linux), App Service Plan, optional Key Vault + Insights
- **Testing**: Pytest, pytest-cov

---

## 📁 Folder Structure

```
devops-multi-stage-deployment/
├── .azure-pipelines/
│   └── ci-cd.yml                     # Azure DevOps pipeline
├── bicep/
│   ├── main.bicep                    # Infra entry point
│   ├── modules/
│   │   ├── plan.bicep                # Shared App Service Plan
│   │   └── webapp.bicep              # Web App module
│   ├── environments/
│   │   ├── dev.bicep                 # Dev-specific settings
│   │   ├── staging.bicep             # Staging-specific settings
│   │   └── prod.bicep                # Prod-specific settings
│   └── parameters/
│       ├── dev.parameters.json
│       ├── staging.parameters.json
│       └── prod.parameters.json
├── scripts/
│   ├── deploy.sh                     # App deploy via Azure CLI
│   ├── cleanup.sh                    # Clean up all resources
├── src/
│   ├── main.py                       # FastAPI entry point
│   ├── templates/                    # Jinja2 HTML files
│   └── static/                       # CSS styles
├── tests/
│   └── test_main.py                  # Unit tests
├── requirements.txt
├── Dockerfile
└── README.md
```

---

## 🧪 Testing

- Run tests: `pytest`
- Enforced in pipeline with min coverage (`--cov-fail-under=80`)
- Test results + code coverage published to Azure DevOps UI

---

## 🧠 How to Deploy

Use Azure CLI for Bicep:
```bash
az deployment group create \
  --resource-group NickClarkRG \
  --template-file bicep/main.bicep \
  --parameters environment=prod appInsightsKey='xxx' keyVaultUri='https://yourkv.vault.azure.net'
```

---

## 🖼️ Architecture

> ![Architecture Diagram](link-to-diagram-once-final.png)

---

## 🧪 In Progress

- [ ] Add `deploy.bicep.sh` wrapper
- [ ] Mirror Bicep infra in Terraform
- [ ] Connect to Azure Monitor + Alert Rules
- [ ] Generate dashboard snapshot preview

---

## 👋 Author

**Nick Clark**  
🔗 [LinkedIn](https://www.linkedin.com/in/nicholas-a-clark/)  
📁 [GitHub](https://github.com/NickTheDevOpsGuy)

#DevOps #AzureDevOps #AZ400 #CI_CD #IaC #FastAPI #NickDoesDevOps

---

## ✅ Project Status: Complete

This project represents a production-ready Azure DevOps deployment pipeline with full testing, observability hooks, and secure practices baked in.

If you're looking for a real-world DevOps example to learn from, fork it and start hacking.

> Built with 💙 by [NickDoesDevOps](https://www.linkedin.com/in/nicholas-a-clark/) — world domination never looked so clean.

---

## ✨ How to Contribute
* Fork the repo
* Make changes on a feature branch
* Submit a pull request
