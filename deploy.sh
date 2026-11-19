#!/usr/bin/env bash
# Deploy resume site to S3 and invalidate CloudFront cache.
# Usage: ./deploy.sh   (run from the site folder)
set -euo pipefail

BUCKET="diadechko-com-site"
DISTRIBUTION_ID="E14RA3LVSOW73R"   # CloudFront -> Distributions -> ID (starts with E)

# HTML / XML / TXT: short cache so updates show up fast
aws s3 sync . "s3://${BUCKET}/" --delete \
  --exclude "*" --include "*.html" --include "*.xml" --include "*.txt" \
  --cache-control "public, max-age=300"

# Static assets: long cache
aws s3 sync . "s3://${BUCKET}/" --delete \
  --exclude "*" --include "*.svg" --include "*.css" --include "*.png" \
  --include "*.jpg" --include "*.webp" --include "*.pdf" \
  --exclude ".preview/*" \
  --cache-control "public, max-age=86400"

aws cloudfront create-invalidation --distribution-id "${DISTRIBUTION_ID}" --paths "/*" \
  --query 'Invalidation.Id' --output text
