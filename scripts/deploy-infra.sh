#!/usr/bin/env bash
set -euo pipefail

TF_DIR="./terraform"

echo "=========================================================="
echo " Provisioning S3 & CloudFront via Terraform"
echo "=========================================================="

cd "${TF_DIR}"
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

echo "=========================================================="
echo " Infrastructure Provisioned Successfully!"
echo " S3 Bucket: "
terraform output s3_bucket_name
echo " CloudFront URL: "
terraform output cloudfront_domain_name
echo " CloudFront Dist ID: "
terraform output cloudfront_distribution_id
echo "=========================================================="
