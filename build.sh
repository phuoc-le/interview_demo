#!/bin/bash
# Variables for registry and image names

REGISTRY_URL=xxxxxx.dkr.ecr.us-east-1.amazonaws.com
FRONTEND_IMAGE=frontend-app
BACKEND_IMAGE=backend-app

# Go to the source code of the application
cd application

# Build backend image
docker build -f Dockerfile.backend -t $REGISTRY_URL/$BACKEND_IMAGE .

# Build frontend image
docker build -f  Dockerfile.frontend -t $REGISTRY_URL/$FRONTEND_IMAGE .

# Push to registry
docker push $REGISTRY_URL/$BACKEND_IMAGE
docker push $REGISTRY_URL/$FRONTEND_IMAGE
