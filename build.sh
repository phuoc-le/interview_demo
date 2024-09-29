#!/bin/bash
# Variables for registry and image names

AWS_ACCOUNT_ID="xxxxxx"
AWS_REGION="us-east-1"
REGISTRY_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
BACKEND_IMAGE=backend-app
BACKEND_TAG=v1.0.0-demo
FRONTEND_IMAGE=frontend-app
FRONTEND_TAG=v1.0.0-demo


# Go to the source code of the application
cd application

# Build backend image
docker build -f Dockerfile.backend -t $REGISTRY_URL/$BACKEND_IMAGE:$BACKEND_TAG .

# Build frontend image
docker build -f  Dockerfile.frontend -t $REGISTRY_URL/$FRONTEND_IMAGE:$FRONTEND_TAG .

# Push to registry
docker push $REGISTRY_URL/$BACKEND_IMAGE:$BACKEND_TAG
docker push $REGISTRY_URL/$FRONTEND_IMAGE:$FRONTEND_TAG
