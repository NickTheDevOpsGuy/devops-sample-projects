# 🧪 NickDoesDevOps: Node.js CI/CD Example with GHCR + GitHub Actions

This project demonstrates a **Node.js application** with a **CI/CD pipeline** using GitHub Actions. The pipeline runs **Jest for unit testing**, and optionally **builds/pushes a Docker image** to a registry like GHCR (GitHub Container Registry).

![CI](https://github.com/NickTheDevOpsGuy/devops-sample-projects/actions/workflows/node-ci.yml/badge.svg?branch=develop)

> _World Domination, One Pipeline at a Time™_

This is a **Node.js demo project** showcasing a production-grade DevOps CI/CD pipeline with:

* ✅ GitHub Actions matrix testing (Node 16, 18, 20)
* ✅ Jest test coverage
* ✅ Docker image build & push to GitHub Container Registry (GHCR)
* ✅ Hardened Dockerfile using a non-root user
* ✅ Commit SHA-based Docker image tags
* ✅ Coverage artifacts uploaded with each run

---

## 🧱 Project Structure

```bash
.github/
├── workflows/
│   └── node-ci.yml           # GitHub Actions workflow file
ci-cd-github-actions/
├── app.js                    # Simple Node.js HTTP server
├── Dockerfile               # Docker image definition
├── package.json             # Node.js project metadata
├── tests/
│   └── app.test.js          # Example Jest test
```
---

## ⚙️ Setup Instructions

1.  Clone the repo

```bash
git clone https://github.com/your-username/ci-cd-github-actions.git
cd ci-cd-github-actions
```

2.  Install dependencies

```bash
npm install
```

3.  Run locally

```bash
npm start
```

4.  Run tests

```bash
npm test
```

---

## 🐙 GitHub Actions CI Pipeline
Located in .github/workflows/ci.yml, this pipeline runs on every push and pull request to main. It includes the following steps:

* 🔁 Matrix testing across Node.js 16, 18, and 20
* 🧪 Jest tests with HTTP assertions (via Supertest)
*🐳 Docker build + push to GHCR with both latest and commit SHA tags
*💾 Coverage artifacts uploaded to Actions
*🔐 Secrets-based login for secure registry auth

---

## 🐳 Docker
This repo includes a Dockerfile to containerize the app:

1.  Build the image
```bash
docker build -t nickdevops/node-ci-app .
```
2.  Run the container

```bash
docker run -p 3000:3000 nickdevops/node-ci-app
```

---

📦 Optional: GitHub Container Registry (GHCR)
To build and push to GHCR, add the following secrets to your GitHub repo:

* CR_USERNAME – Your GitHub username
* CR_PAT – A GitHub Personal Access Token with write:packages and read:packages

Then extend your GitHub Actions workflow to include Docker build and push steps.

🧪 Sample Output
```bash
$ curl http://localhost:3000
Hello from DevOps Domination Server!
```

## 👑 Part of the NickDoesDevOps Portfolio  
Follow more projects like this at [github.com/NickTheDevOpsGuy](https://github.com/NickTheDevOpsGuy)

> _World Domination, One Pipeline at a Time™_
