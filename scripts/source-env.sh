#!/bin/bash

cp .env.template .env
cp cloudbuild.yaml.template cloudbuild.yaml

PROJECT_ID=$(gcloud config get project)

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")

sed -i 's\${PROJECT_ID}\'"$PROJECT_ID"'\g' .env
sed -i 's\${PROJECT_NUMBER}\'"$PROJECT_NUMBER"'\g' .env
sed -i 's\${REGION}\'"$REGION"'\g' .env
sed -i 's\${ARTIFACT_REPO_NAME}\'"$ARTIFACT_REPO_NAME"'\g' .env
sed -i 's\${ARTIFACT_REPO_NAME}\'"$ARTIFACT_REPO_NAME"'\g' cloudbuild.yaml
sed -i 's\${CSR_REPO_NAME}\'"$CSR_REPO_NAME"'\g' .env

sed -i 's\${CLUSTER_NAME1}\'"$CLUSTER_NAME1"'\g' .env
sed -i 's\${ZONE1}\'"$ZONE1"'\g' .env
sed -i 's\${CLUSTER_NAME2}\'"$CLUSTER_NAME1"'\g' .env
sed -i 's\${ZONE2}\'"$ZONE2"'\g' .env
sed -i 's\${CLUSTER_NAME3}\'"$CLUSTER_NAME1"'\g' .env
sed -i 's\${ZONE3}\'"$ZONE3"'\g' .env
