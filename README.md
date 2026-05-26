# Automated DevOps Pipeline with Infrastructure Monitoring

Provisioned complete AWS infrastructure and automated application deployment using Terraform, GitHub Actions, Docker, Kubernetes, Prometheus, and Grafana.

[![CI/CD Pipeline](https://github.com/Mounikavasireddy8/devops-pipeline-monitoring/actions/workflows/cicd.yml/badge.svg)](https://github.com/Mounikavasireddy8/devops-pipeline-monitoring/actions)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat&logo=grafana&logoColor=white)

> **Production-style end-to-end DevOps project** — git push to live AWS deployment, fully automated.
> Built by **Mounika Vasireddy** | B.Tech CS 2023 | Andhra Pradesh, India

---

## What This Project Does

One `git push` triggers a complete automated pipeline that:
- Builds and tests a Docker container
- Pushes the image to Amazon ECR
- Deploys to AWS EC2 provisioned by Terraform
- Starts Prometheus monitoring and Grafana dashboards
- Kubernetes manages 3 replicas with auto-scaling

**Zero manual intervention. Fully automated deployment pipeline using production-grade DevOps practices.**

---

## Architecture

![Architecture Diagram](screenshots/architecture-diagram.png)

---

## Live Deployment Screenshots

### Application Live on AWS EC2
![App on AWS](screenshots/app-aws.png)

### GitHub Actions Pipeline — Successful Run
![GitHub Actions](screenshots/github-actions.png)

### Prometheus Monitoring (port 9090)
![Prometheus](screenshots/prometheus.png)

### Grafana Dashboard (port 3000)
![Grafana](screenshots/grafana.png)

### Kubernetes — All Pods Running
![Kubernetes](screenshots/kubectl-pods.png)

### Application on Kubernetes (minikube)
![App on K8s](screenshots/app-kubernetes.png)

---

## Pipeline Flow
git push
│
▼
GitHub Actions triggers
│
├── docker build -t devops-pipeline:$SHA .
│
├── Test: docker run → curl health check → pass/fail
│
├── docker push → Amazon ECR (:latest + :$SHA)
│
└── SSH into EC2 (appleboy/ssh-action)
│
├── docker pull latest image
├── docker stop old container
└── docker run new container → app live

---

## Tech Stack

| Category | Technology | Purpose |
|---|---|---|
| Containerization | Docker, nginx:1.25-alpine | Package and serve application |
| CI/CD | GitHub Actions | Automated pipeline on every push |
| Infrastructure as Code | Terraform | Provision all AWS resources |
| Cloud Platform | AWS EC2, ECR, VPC, IAM | Cloud hosting and registry |
| Orchestration | Kubernetes, minikube, HPA | Container management and scaling |
| Monitoring | Prometheus, Grafana | Metrics collection and visualization |
| Operating System | Amazon Linux 2023 | EC2 server OS |
| Security | IAM Roles, GitHub Secrets | Zero hardcoded credentials |
| Version Control | Git, GitHub | Source code management |

---

## AWS Infrastructure (Terraform)

All resources provisioned with single `terraform apply` command:

| Resource | Details |
|---|---|
| VPC | 10.0.0.0/16 — custom network |
| Public Subnet | 10.0.1.0/24 — ap-south-1a |
| Internet Gateway | Public internet access |
| Route Table | Public routing configuration |
| Security Group | Ports 22, 80, 9090, 3000 |
| EC2 Instance | t3.micro — Amazon Linux 2023 |
| IAM Role | AmazonEC2ContainerRegistryReadOnly |
| IAM Instance Profile | Attached to EC2 — no hardcoded keys |
| Amazon ECR | Private Docker image registry |

---

## Kubernetes Configuration

| Component | Details |
|---|---|
| Namespace | devops-pipeline — logical isolation |
| Deployment | 3 replicas — RollingUpdate strategy |
| Service | NodePort — port 30080 |
| ConfigMap | APP_NAME, ENVIRONMENT, APP_VERSION |
| Secret | Sensitive credentials management |
| HPA | Auto-scale 2–8 pods at 60% CPU |
| Liveness Probe | HTTP GET / every 10s — restart if fail |
| Readiness Probe | HTTP GET / every 5s — traffic control |

---

## Security Best Practices

- **IAM roles** — EC2 accesses ECR via role, zero hardcoded AWS credentials
- **GitHub Secrets** — AWS keys, EC2 host, private key stored as encrypted secrets
- **Non-root Docker user** — container runs as `appuser` not root
- **Alpine base image** — nginx:1.25-alpine (23MB vs 187MB) — minimal attack surface
- **Security Groups** — only required ports open (22, 80, 9090, 3000)
- **.gitignore** — terraform state files and .pem keys excluded from repository
- **Kubernetes Secrets** — sensitive data separated from ConfigMap

---

## How to Run Locally

```bash
# Clone repository
git clone https://github.com/Mounikavasireddy8/devops-pipeline-monitoring
cd devops-pipeline-monitoring

# Run with Docker Compose
docker compose up -d

# Access
# Application : http://localhost:8080
# Prometheus  : http://localhost:9090
# Grafana     : http://localhost:3000 (admin / admin123)

# Stop
docker compose down
```

---

## Deploy to AWS with Terraform

```bash
# Configure AWS CLI
aws configure

# Push image to ECR first
aws ecr create-repository --repository-name devops-pipeline --region ap-south-1
aws ecr get-login-password --region ap-south-1 | docker login --username AWS \
  --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com
docker build -t YOUR_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/devops-pipeline:latest .
docker push YOUR_ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/devops-pipeline:latest

# Deploy infrastructure
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# Outputs
# app_url        = http://PUBLIC_IP
# prometheus_url = http://PUBLIC_IP:9090
# grafana_url    = http://PUBLIC_IP:3000

# Destroy after use (avoid charges)
terraform destroy -auto-approve
```

---

## Kubernetes Deployment

```bash
# Start minikube
minikube start

# Build and load image
docker build -t devops-pipeline:latest .
minikube image load devops-pipeline:latest

# Deploy all resources
kubectl apply -f kubernetes/

# Verify everything running
kubectl get all -n devops-pipeline

# Access application
minikube service devops-pipeline-service -n devops-pipeline --url
```

---

## GitHub Secrets Required

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key for ECR authentication |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `EC2_HOST` | EC2 public IP address |
| `EC2_PRIVATE_KEY` | Contents of .pem key file for SSH |

---

## Project Structure
devops-pipeline-monitoring/
├── .github/
│   └── workflows/
│       └── cicd.yml          # GitHub Actions — complete CI/CD pipeline
├── app/
│   └── index.html            # Web application
├── kubernetes/
│   ├── namespace.yaml        # Namespace: devops-pipeline
│   ├── configmap.yaml        # Non-sensitive configuration
│   ├── secret.yaml           # Sensitive data management
│   ├── deployment.yaml       # 3 replicas + probes + resource limits
│   ├── service.yaml          # NodePort service
│   └── hpa.yaml              # HPA — auto-scale 2–8 pods
├── monitoring/
│   └── prometheus.yml        # Prometheus scrape configuration
├── terraform/
│   ├── main.tf               # VPC, EC2, IAM, Security Groups
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # app_url, prometheus_url, grafana_url
│   └── terraform.tfvars      # Variable values (not committed)
├── screenshots/              # Proof of live deployment
├── Dockerfile                # nginx:1.25-alpine, non-root user
├── docker-compose.yml        # Local: app + prometheus + grafana
├── nginx.conf                # nginx with /metrics endpoint
├── .dockerignore             # Exclude unnecessary files from build
├── .gitignore                # Exclude state files and secrets
└── README.md                 # This file

---

## Future Improvements

- Deploy on **Amazon EKS** — production Kubernetes on AWS
- Add **HTTPS** using nginx + AWS Certificate Manager
- Implement **ArgoCD GitOps** — declarative deployment
- Add **Helm charts** for parameterized K8s deployment
- Integrate **ELK Stack** — centralized logging
- Add **Terraform remote state** on S3 with DynamoDB locking
- Configure **custom domain** with Route 53

---

## Interview Answer

> "I built a complete automated DevOps pipeline where a git push triggers
> GitHub Actions which builds and tests a Docker image, pushes it to
> Amazon ECR, and deploys it to AWS EC2 provisioned by Terraform.
> The Kubernetes configuration manages 3 replicas with auto-scaling
> from 2 to 8 pods. Prometheus and Grafana provide real-time monitoring.
> The entire infrastructure is code — reproducible with one terraform apply."

---

## Author

**Mounika Vasireddy**
B.Tech Computer Science — 2023 | Andhra Pradesh, India

[![GitHub](https://img.shields.io/badge/GitHub-Mounikavasireddy8-181717?style=flat&logo=github)](https://github.com/Mounikavasireddy8)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-mounikavasireddy-0077B5?style=flat&logo=linkedin)](https://linkedin.com/in/mounikavasireddy)
[![Email](https://img.shields.io/badge/Email-vasireddymounikachowdary%40gmail.com-D14836?style=flat&logo=gmail)](mailto:vasireddymounikachowdary@gmail.com)

---

*Deployed on AWS EC2 — ap-south-1 (Mumbai) | Infrastructure destroyed after testing to avoid charges | Can redeploy in under 5 minutes*

