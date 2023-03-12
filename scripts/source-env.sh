#!/bin/bash

if [ -f .env ]; then
  rm .env
fi

if [ -f cloud*.yaml ]; then
  rm cloud*.yaml
fi

cp ./templates/.env .env
cp ./templates/cloudbuild.yaml cloudbuild.yaml
cp ./templates/clouddeploy.yaml clouddeploy.yaml
# cp ./apps/backend00/templates/skaffold.yaml apps/backend00/skaffold.yaml

PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")

sed -i 's\${PROJECT_ID}\'"$PROJECT_ID"'\g' .env
sed -i 's\${PROJECT_ID}\'"$PROJECT_ID"'\g' cloud*.yaml

sed -i 's\${PROJECT_NUMBER}\'"$PROJECT_NUMBER"'\g' .env
sed -i 's\${REGION}\'"$REGION"'\g' .env
sed -i 's\${ARTIFACT_REPO_NAME}\'"$ARTIFACT_REPO_NAME"'\g' .env
sed -i 's\${ARTIFACT_REPO_NAME}\'"$ARTIFACT_REPO_NAME"'\g' cloud*.yaml
sed -i 's\${CSR_REPO_NAME}\'"$CSR_REPO_NAME"'\g' .env

sed -i 's\${CLUSTER_DEV_NAME}\'"$CLUSTER_DEV_NAME"'\g' .env
sed -i 's\${CLUSTER_DEV_NAME}\'"$CLUSTER_DEV_NAME"'\g' cloud*.yaml
sed -i 's\${CLUSTER_DEV_LOC}\'"$CLUSTER_DEV_LOC"'\g' .env
sed -i 's\${CLUSTER_DEV_LOC}\'"$CLUSTER_DEV_LOC"'\g' cloud*.yaml

sed -i 's\${CLUSTER_PROD_NAME}\'"$CLUSTER_PROD_NAME"'\g' .env
sed -i 's\${CLUSTER_PROD_NAME}\'"$CLUSTER_PROD_NAME"'\g' cloud*.yaml
sed -i 's\${CLUSTER_PROD_LOC}\'"$CLUSTER_PROD_LOC"'\g' .env
sed -i 's\${CLUSTER_PROD_LOC}\'"$CLUSTER_PROD_LOC"'\g' cloud*.yaml
