#!/usr/bin/env bash
set -euo pipefail

TF_DIR="./terraform"

echo "=========================================================="
echo " [CAUTION] Destroying S3 & CloudFront Resources"
echo "=========================================================="

read -p "Are you sure you want to destroy all resources? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  cd "${TF_DIR}"
  terraform destroy -auto-approve
  echo "[SUCCESS] All AWS resources destroyed cleanly."
else
  echo "[ABORT] Teardown cancelled."
fi
