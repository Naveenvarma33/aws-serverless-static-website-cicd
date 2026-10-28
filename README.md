# Serverless Static Website Hosting with CI/CD on AWS

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS S3](https://img.shields.io/badge/AWS-S3%20Bucket-569A31?logo=amazons3&logoColor=white)](https://aws.amazon.com/s3/)
[![CloudFront](https://img.shields.io/badge/AWS-CloudFront%20CDN-D05C4C?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/cloudfront/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)

---

## 📌 Project Overview

This project implements a secure, highly available, and cost-efficient **Serverless Static Website Hosting Platform** on AWS using **Terraform (Infrastructure as Code)** and **GitHub Actions**.

Rather than running expensive virtual machines (EC2) to host static web content, this architecture uses:
1. **Amazon S3** as a private object storage origin.
2. **Amazon CloudFront** as a global Content Delivery Network (CDN) with modern **Origin Access Control (OAC)**.
3. **GitHub Actions** to automate deployments on every Git commit with instant cache invalidation.

```mermaid
flowchart LR
    Dev["Developer (Git Push)"] -->|Trigger Push| GHA["GitHub Actions CI/CD"]
    
    subgraph CI_CD ["Automation Workflow"]
        GHA -->|1. Sync Files| S3["Amazon S3 Bucket\n(Strictly Private)"]
        GHA -->|2. Invalidate Cache| CF["Amazon CloudFront CDN\n(Edge PoP Locations)"]
    end

    subgraph EndUsers ["Public Internet"]
        Users["Global Visitors"] -->|HTTPS :443| CF
    end

    CF -->|Secure OAC SigV4| S3
```

---

## 🎯 Resume Bullet Points (Copy & Paste)

You can place this directly into your resume under your Projects section:

> **Serverless Static Website & Automated CI/CD Platform**  
> *AWS (S3, CloudFront, IAM), Terraform, GitHub Actions, HTML5/CSS3*
> - **Provisioned a secure serverless hosting platform** using Terraform, configuring a private Amazon S3 bucket, CloudFront CDN distribution, and custom 404 error responses.
> - **Secured S3 bucket access using Origin Access Control (OAC)**, enforcing TLS encryption (HTTP-to-HTTPS redirect) and blocking all direct public internet access.
> - **Built a GitHub Actions CI/CD pipeline** that triggers on code commits to automatically sync updated assets to S3 and invalidate CloudFront edge caches for zero-downtime updates.
> - **Optimized global delivery performance and cloud costs**, achieving sub-50ms edge latency while operating entirely within the AWS Free Tier ($0/month infrastructure cost).

---

## 📁 Repository Structure

```text
aws-serverless-static-website-cicd/
├── website/                             # Static Web Application Source
│   ├── index.html                       # Responsive HTML5 landing page
│   ├── error.html                       # Custom 404 error page
│   ├── style.css                        # Modern CSS design system
│   └── app.js                           # Interactive edge latency telemetry
├── terraform/                           # Infrastructure as Code (IaC)
│   ├── main.tf                          # S3 bucket, CloudFront distribution, OAC, bucket policy
│   ├── variables.tf                     # Configurable inputs (region, project name)
│   ├── outputs.tf                       # CloudFront URL, S3 bucket name, distribution ID
│   ├── versions.tf                      # AWS provider (~> 5.0) requirements
│   └── terraform.tfvars.example         # Sample variable values
├── .github/
│   └── workflows/
│       └── deploy.yml                   # Automated GitHub Actions sync & invalidation workflow
├── scripts/                             # Automation helper scripts
│   ├── deploy-infra.sh                  # Terraform apply runner
│   ├── destroy-infra.sh                 # Safe teardown runner
│   └── sync-manual.sh                   # Manual CLI deploy script
├── .gitignore
└── README.md                            # Comprehensive project guide
```

---

## 🔒 Key Security Architecture: Why Origin Access Control (OAC)?

Older AWS tutorials often tell people to enable *"S3 Static Website Hosting"* and make the entire S3 bucket publicly readable (`0.0.0.0/0`). **This is a security anti-pattern in modern cloud engineering.**

In this project:
* **The S3 bucket is completely private.** All 4 AWS Block Public Access settings are set to `true`.
* **Origin Access Control (OAC):** We use AWS's latest recommended signing mechanism (SigV4) to allow **only** our CloudFront distribution ARN to retrieve objects from S3.
* **HTTPS Enforcement:** CloudFront automatically redirects any insecure `http://` requests to secure `https://` with TLS 1.2+.

---

## 🚀 Step-by-Step Deployment Guide

### Prerequisites
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) installed and configured (`aws configure`).
- [Terraform](https://www.terraform.io/downloads.html) installed (>= 1.5.0).

### 1. Provision Infrastructure with Terraform
```bash
cd terraform

# Initialize providers
terraform init

# Review execution plan
terraform plan

# Provision S3 and CloudFront
terraform apply -auto-approve
```

Upon completion, Terraform will output your live endpoints:
- `s3_bucket_name`: e.g., `serverless-static-site-prod-abc123`
- `cloudfront_distribution_id`: e.g., `E1234567890ABC`
- `cloudfront_domain_name`: e.g., `https://d111111abcdef8.cloudfront.net`

### 2. Upload the Website Files
You can upload the website files immediately using the helper script:
```bash
cd ..
./scripts/sync-manual.sh <S3_BUCKET_NAME> <CLOUDFRONT_DIST_ID>
```
Or open the `cloudfront_domain_name` directly in your browser!

---

## 🔄 Setting Up Automated GitHub Actions CI/CD

To make the website deploy automatically whenever you run `git push`:

1. Push this repository to your GitHub account.
2. In your GitHub repository, go to **Settings > Secrets and variables > Actions**.
3. Add the following repository secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS IAM access key ID.
   - `AWS_SECRET_ACCESS_KEY`: Your AWS IAM secret access key.
   - `AWS_REGION`: `us-east-1` (or your chosen region).
   - `S3_BUCKET_NAME`: The S3 bucket name from `terraform output`.
   - `CLOUDFRONT_DIST_ID`: The CloudFront distribution ID from `terraform output`.

Now, anytime you edit `website/index.html` and commit, GitHub Actions will:
1. Sync updated files to S3 with optimal `Cache-Control` headers.
2. Invalidate the CloudFront cache (`/*`) so changes appear instantly worldwide.

---

## 🧹 Infrastructure Teardown

To delete all provisioned AWS resources and ensure zero lingering costs:

```bash
cd terraform
terraform destroy -auto-approve
```

---

## 🎓 Interview Cheat Sheet: 5 Common Questions & Bulletproof Answers

When discussing this project in a job interview, here are the exact answers to common questions:

### 1. "Why host on S3 and CloudFront instead of an EC2 instance or Nginx?"
> *"Static websites consist of static assets (HTML, CSS, JS) that do not require server-side runtime compute. By using S3 and CloudFront, we achieve a serverless architecture with 99.99% availability, zero server maintenance/patching, sub-50ms edge latency via CloudFront's global Points of Presence, and virtually $0 in hosting costs under the AWS Free Tier."*

### 2. "How do you protect the S3 bucket from being accessed directly by the public?"
> *"I enabled AWS S3 Block Public Access to disable public ACLs and bucket policies. Then, I configured CloudFront Origin Access Control (OAC), which uses SigV4 authentication. The S3 bucket policy grants `s3:GetObject` permission strictly to the CloudFront service principal with a condition matching our specific distribution ARN."*

### 3. "What is cache invalidation and why did you put it in the CI/CD pipeline?"
> *"CloudFront caches static files at edge locations based on TTL (Time-To-Live). If you update a file in S3, edge servers would still serve the old cached version until the TTL expires. In our GitHub Actions pipeline, we run `aws cloudfront create-invalidation --paths '/*'` after syncing to S3, which forces edge nodes to fetch the latest version immediately for users."*

### 4. "What is the difference between OAC and the older OAI (Origin Access Identity)?"
> *"OAI is AWS's legacy method and only supports basic S3 operations without KMS SSE-KMS encryption or all AWS regions. OAC (Origin Access Control) is AWS's modern standard that uses SigV4 signing, supports server-side encryption with KMS, and has better security posture."*

### 5. "How does CloudFront handle a 404 error?"
> *"I configured custom error responses in the CloudFront distribution in Terraform. When a visitor requests a non-existent URL or file, CloudFront catches the 404 or 403 HTTP status from S3 and serves our custom `error.html` page smoothly."*
