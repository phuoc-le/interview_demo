##Interview Demo Project with Blog Feature
This project extends the hackathon-starter template by adding a blog post system and containerizing the application using Docker. It deploys the application to AWS EKS using Terraform, with CI/CD automation handled by Jenkins.

###Features
- Blog post system with routes for creating, reading, updating, and deleting blog posts.
- Dockerized backend and frontend services.
- Infrastructure provisioning with Terraform on AWS.
- Kubernetes manifests for deployment.
- CI/CD pipeline using Jenkins for automated testing, Docker builds, and deployment to Kubernetes.

###Prerequisites
- AWS Account
- Docker installed locally
- Terraform installed locally
- Jenkins server (can be installed locally or via AWS)
- kubectl for interacting with Kubernetes
- Node.js and npm
- jq

##Setup Instructions

###AWS Setup with Terraform
1. Install Terraform: If not installed, download Terraform here.
2. Configure AWS CLI:
    ```
    aws configure
    ```
   Enter your AWS Access Key ID, Secret Access Key, region, and output format.
3. Provision Infrastructure
    - Initialize Terraform
         ```
         terraform init
         ```
    - Plan Terraform configuration
        ```
        terraform apply -out demo
        ```
    - Apply Terraform configuration
        ```
        terraform apply demo
        ```

   This step will create:
    - An EKS cluster for deploying the app.
    - ECR repositories for storing the frontend and backend Docker images.

4. Verify Cluster Access: Once the EKS cluster is created, update your kubeconfig to access the cluster
    ```
    aws eks update-kubeconfig --name demo-cluster --region us-east-1 --profile development
    ```
5. Deploy to Kubernetes: Apply the Kubernetes manifests for the frontend and backend
    ```
    kubectl apply -f k8s/backend-deployment.yaml
    kubectl apply -f k8s/frontend-deployment.yaml
    ```

###Jenkins Setup
1. Install Jenkins:
- Follow Jenkins installation instructions here.
- Install the necessary plugins: AWS Credentials, Kubernetes CLI, Docker, Terraform, and Git.
2. Configure Jenkins Credentials:
- AWS: Add your AWS access keys in Jenkins Credentials.
3. Set up Jenkins Pipeline:
- Create a Jenkinsfile.backend in the root of the repository to define the pipeline stages (e.g., test, build, push, and deploy).
- Create a Jenkinsfile.frontend in the root of the repository to define the pipeline stages (e.g., test, build, push, and deploy).
4. Run the Pipeline: Jenkins will automatically:
- Pull the latest code from GitHub.
- Run tests.
- Build Docker images for the frontend and backend.
- Push the images to AWS ECR.
- Deploy the updated application to the EKS cluster.

### Application

1. Clone the Repository:
```
git clone https://github.com/phuoc-le/interview_demo.git
cd application
```
2. Install Dependencies:
```
npm install
```
3. Copy .env.example into .env
```
cp .env.example .env
```
4. Start Local Development Server
```
npm run backend
npm run frontend
```
4. Create fake data to test
```
npm run seed
```
5. Run Tests (Optional)
```
npm run test
```

