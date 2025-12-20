#!/bin/bash
set -e

VALUES_FILE="helm/mern-chart/values.yaml"

FRONTEND_TAG=$1
BACKEND_TAG=$2

if [[ -z "$FRONTEND_TAG" || -z "$BACKEND_TAG" ]]; then
  echo "Usage: update-values.sh <frontend-tag> <backend-tag>"
  exit 1
fi

echo "Updating Helm values.yaml…"

# Update frontend tag safely
yq e -i ".frontend.tag = \"$FRONTEND_TAG\"" $VALUES_FILE

# Update backend tag safely
yq e -i ".backend.tag = \"$BACKEND_TAG\"" $VALUES_FILE

echo "✔ Updated frontend.tag = $FRONTEND_TAG"
echo "✔ Updated backend.tag = $BACKEND_TAG"
