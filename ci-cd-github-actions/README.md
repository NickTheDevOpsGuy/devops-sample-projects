# 🚀 CI/CD with GitHub Actions, ESLint, Jest & Docker

This project demonstrates a **Node.js application** with a **CI/CD pipeline** using GitHub Actions. The pipeline runs **ESLint for linting**, **Jest for unit testing**, and optionally **builds/pushes a Docker image** to a registry like GHCR (GitHub Container Registry).

---

## 🧱 Project Structure

```bash
ci-cd-github-actions/
├── app.js                    # Simple Node.js HTTP server
├── Dockerfile               # Docker image definition
├── package.json             # Node.js project metadata
├── tests/
│   └── sum.test.js          # Example Jest test
└── .github/
    └── workflows/
        └── ci.yml           # GitHub Actions workflow file
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

5. Run ESLint

```bash
npx eslint .
```

---

## 🐙 GitHub Actions CI Pipeline
Located in .github/workflows/ci.yml, this pipeline runs on every push and pull request to main. It includes the following steps:

* 🔄 Checkout code
* 🟦 Set up Node.js
* 📦 Install dependencies
* 🔍 Lint code with ESLint
* 🧪 Run tests using Jest

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

## 👑 Built for DevOps Domination
This project is part of the NickDoesDevOps portfolio.
Follow along the journey at github.com/NickTheDevOpsGuy

```yaml
Want me to:
- Include GHCR push in `ci.yml`?
- Add badges (e.g. CI status, coverage)?
- Auto-generate GitHub Pages for documentation?

Your DevOps empire awaits 🧱🌍
```
