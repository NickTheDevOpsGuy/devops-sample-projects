# 🚀 DevOps Multi-Stage Deployment (AZ-400 Sample Project)

This project demonstrates a **real-world Azure DevOps multi-stage pipeline** for deploying a containerized FastAPI web app to **three environments**: Dev, Staging, and Production.  
It features **artifact promotion**, **manual approvals**, and **Key Vault secret integration** — aligned with **AZ-400 certification best practices**.

---

## 🧱 Tech Stack

- 🐍 [FastAPI](https://fastapi.tiangolo.com/) (Python 3.11)
- 🐳 Docker
- ☁️ Azure Web Apps (Linux)
- 🔐 Azure Key Vault
- 🔁 Azure DevOps YAML Pipelines

---

## 🌐 Web App Features

- Dynamic homepage with **visitor counter**
- Functional **contact form**
- Simple, styled **Jinja2 templates** + CSS
- Built with `uvicorn` and runs in a Docker container

---

## 🛠️ Folder Structure

```plaintext
devops-multi-stage-deployment/
├── requirements.txt                    # requirements.txt for python build
├── .env.template                       # env template file for Azure
├── .gitignore                          # ignore file for git
├── .azure-pipelines/                   # Azure DevOps pipeline config
│   └── pipeline.yml                    # Multi-stage YAML pipeline
│
├── scripts/                            # Optional CLI deployment helper (az CLI)
│   └── deploy.sh                       # Script to deploy to Azure Web App
│   └── cleanup.sh                      # Script to clean up resources
│
├── src/                                # FastAPI web app
│   ├── main.py                         # App entry point with web logic
│   ├── templates/                      # HTML templates
│   │   ├── index.html
│   │   └── contact.html
│   └── static/                         # CSS styles
│       └── style.css
│
├── Dockerfile                          # Container build file
├── README.md                           # Full project overview and instructions
```

---

## 🔁 Azure DevOps Pipeline Overview

The YAML pipeline includes:
- ✅ **Build Stage**: Build and push Docker image, publish artifact
- ✅ **Dev Stage**: Deploy to Dev environment
- ✅ **Staging Stage**: Deploy to staging Web App (requires manual approval)
- ✅ **Prod Stage**: Deploy to production Web App (requires approval)

Artifacts are **built once** and reused across stages for consistency.

---

## 🔐 Secrets & Key Vault

Secrets like database strings or email credentials should be stored in **Azure Key Vault** and accessed via **Variable Groups** in Azure DevOps.

---

## 📦 Build & Run Locally

```bash
# Build Docker image
docker build -t fastapi-devops-app .

# Run the container locally
docker run -p 8080:80 fastapi-devops-app
```

Then visit http://localhost:8080

---

## 💡 Author

Nick Clark
👨‍💻 [LinkedIn](https://www.linkedin.com/in/nicholas-a-clark/)  
📂 [GitHub: NickTheDevOpsGuy](https://github.com/NickTheDevOpsGuy)
