#!/bin/bash
# Variables for registry and image names
REGISTRY_URL=your-registry-url
FRONTEND_IMAGE=frontend-app
BACKEND_IMAGE=backend-app

# Build backend image
docker build -f Dockerfile.backend -t $REGISTRY_URL/$BACKEND_IMAGE .

# Build frontend image
docker build -f Dockerfile.frontend -t $REGISTRY_URL/$FRONTEND_IMAGE .

# Push to registry
docker push $REGISTRY_URL/$BACKEND_IMAGE
docker push $REGISTRY_URL/$FRONTEND_IMAGE
