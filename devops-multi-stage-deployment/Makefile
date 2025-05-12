# Makefile for DevOps Multi-Stage Deployment Project

APP_NAME=fastapi-devops-app
RESOURCE_GROUP=NickClarkRG
IMAGE_TAG=latest

.PHONY: help build test deploy-dev deploy-staging deploy-prod

help:
	@echo "make build           - Build Docker image"
	@echo "make test            - Run pytest with coverage"
	@echo "make deploy-dev      - Deploy app to Azure Web App (dev)"
	@echo "make deploy-staging  - Deploy app to Azure Web App (staging)"
	@echo "make deploy-prod     - Deploy app to Azure Web App (prod)"

build:
	docker build -t $(APP_NAME):$(IMAGE_TAG) .

test:
	pytest --cov=src

deploy-dev:
	./scripts/deploy.sh devops-demo-app-dev $(RESOURCE_GROUP) $(APP_NAME):$(IMAGE_TAG)

deploy-staging:
	./scripts/deploy.sh devops-demo-app-staging $(RESOURCE_GROUP) $(APP_NAME):$(IMAGE_TAG)

deploy-prod:
	./scripts/deploy.sh devops-demo-app-prod $(RESOURCE_GROUP) $(APP_NAME):$(IMAGE_TAG)