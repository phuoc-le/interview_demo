#!/bin/bash

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Error: No environment specified. Usage: ./deploy.sh <environment>"
  exit 1
fi

# Assign the environment. Default is development
ENVIRONMENT="$1:-development"

AWS_ACCOUNT_ID="xxxxxx"
AWS_REGION="us-east-1"
CONTAINER_REGISTRY_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FRONTEND_SERVICE_NAME=frontend-app
BACKEND_SERVICE_NAME=backend-app
BACKEND_TAG=v1.0.0-demo
FRONTEND_TAG=v1.0.0-demo
KUBECONFIG="/opt/.kube/config_${ENVIRONMENT}"
NAMESPACE=default

# Read configuration from config.yaml using yq
DB_URL=$(yq e ".$ENVIRONMENT.db_url" config.yaml)
API_URL=$(yq e ".$ENVIRONMENT.api_url" config.yaml)
FRONTEND_PORT=$(yq e ".$ENVIRONMENT.frontend_port" config.yaml)
BACKEND_PORT=$(yq e ".$ENVIRONMENT.backend_port" config.yaml)

# Check if the environment config is found
if [ -z "$DB_URL" ] || [ -z "$API_URL" ] || [ -z "$APP_PORT" ]; then
  echo "Error: Configuration for environment '$ENVIRONMENT' not found in config.yaml."
  exit 1
fi

# Output the config values (for debugging, can be removed in production)
echo "Deploying for environment: $ENVIRONMENT"
echo "DB URL: $DB_URL"
echo "API URL: $API_URL"
echo "Frontend Port: $FRONTEND_PORT"
echo "Backend Port: $BACKEND_PORT"

# Apply Kubernetes manifests, injecting the environment-specific variables
helm upgrade --install ${BACKEND_SERVICE_NAME} --kubeconfig ${KUBECONFIG} ./deployment/helm-chart -f deployment/environment/${ENVIRONMENT}/values.backend.yaml --set service.port=${BACKEND_PORT} --set service.targetPort=${BACKEND_PORT} --set image.repository=${CONTAINER_REGISTRY_URL}/${BACKEND_SERVICE_NAME} --set image.tag=${BACKEND_TAG}  --set env.configmap.API_URL=${API_URL} --set env.secret.MONGODB_URI=${MONGODB_URI} -n ${NAMESPACE}
helm upgrade --install ${FRONTEND_SERVICE_NAME} --kubeconfig ${KUBECONFIG} ./deployment/helm-chart -f deployment/environment/${ENVIRONMENT}/values.frontend.yaml --set service.port=${FRONTEND_PORT} --set service.targetPort=${FRONTEND_PORT} --set image.repository=${CONTAINER_REGISTRY_URL}/${FRONTEND_SERVICE_NAME} --set image.tag=${FRONTEND_TAG} --set env.configmap.API_URL=${API_URL} -n ${NAMESPACE}

# End of script
