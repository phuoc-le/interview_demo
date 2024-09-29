#!/bin/bash

# Detect OS and install dependencies
OS="$(uname -s)"
case "${OS}" in
    Linux*)     sudo apt update && sudo apt install -y docker.io docker-compose;;
    Darwin*)    brew install docker docker-compose;;
    *)          echo "Unsupported OS"; exit 1;;
esac

# Install Kubernetes (minikube or kind)
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(uname -s | tr '[:upper:]' '[:lower:]')/$(uname -m)/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Set up Jenkins using Docker
if ! command -v jenkins &> /dev/null; then
    echo "Setting up Jenkins..."
    docker run -d --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
fi

# Other setup tasks (Terraform, Kubernetes setup)
