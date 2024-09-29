#!/bin/bash

# Check if environment is provided
if [ -z "$1" ]; then
  echo "Error: No environment specified. Usage: ./deploy.sh <environment>"
  exit 1
fi

# Assign the environment. Default is development
ENVIRONMENT="$1:-development"

# Read configuration from config.yaml using yq
DB_URL=$(yq e ".$ENVIRONMENT.db_url" config.yaml)
API_KEY=$(yq e ".$ENVIRONMENT.api_key" config.yaml)
APP_PORT=$(yq e ".$ENVIRONMENT.app_port" config.yaml)

# Check if the environment config is found
if [ -z "$DB_URL" ] || [ -z "$API_KEY" ] || [ -z "$APP_PORT" ]; then
  echo "Error: Configuration for environment '$ENVIRONMENT' not found in config.yaml."
  exit 1
fi

# Output the config values (for debugging, can be removed in production)
echo "Deploying for environment: $ENVIRONMENT"
echo "DB URL: $DB_URL"
echo "API Key: $API_KEY"
echo "App Port: $APP_PORT"

# Example: Export these values to be used in other scripts or commands
export DB_URL
export API_KEY
export APP_PORT

# Your deployment logic goes here (e.g., Docker, Kubernetes commands)
# Example:
# docker build -t myapp:$ENVIRONMENT .
# docker run -e DB_URL=$DB_URL -e API_KEY=$API_KEY -p $APP_PORT:80 myapp:$ENVIRONMENT

# Apply Kubernetes manifests, injecting the environment-specific variables
kubectl set env deployment/backend-deployment DB_URL=$DB_URL API_KEY=$API_KEY APP_PORT=$APP_PORT
kubectl set env deployment/frontend-deployment API_KEY=$API_KEY APP_PORT=$APP_PORT

# End of script
