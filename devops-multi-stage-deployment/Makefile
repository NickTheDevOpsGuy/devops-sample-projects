build:
	docker build -t fastapi-devops-app .

test:
	pytest --cov=src

deploy-dev:
	./scripts/deploy.sh devops-demo-app-dev NickClarkRG fastapi-devops-app:latest