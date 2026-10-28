#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${1:-}"
DIST_ID="${2:-}"

if [ -z "${BUCKET_NAME}" ] || [ -z "${DIST_ID}" ]; then
  echo "Usage: ./scripts/sync-manual.sh <S3_BUCKET_NAME> <CLOUDFRONT_DIST_ID>"
  exit 1
fi

echo "=========================================================="
echo " 1. Syncing website/ to s3://${BUCKET_NAME}"
echo "=========================================================="
aws s3 sync website/ "s3://${BUCKET_NAME}" --delete

echo "=========================================================="
echo " 2. Invalidating CloudFront Cache for ${DIST_ID}"
echo "=========================================================="
aws cloudfront create-invalidation --distribution-id "${DIST_ID}" --paths "/*"

echo "[SUCCESS] Website synced and CloudFront edge cache invalidated!"
