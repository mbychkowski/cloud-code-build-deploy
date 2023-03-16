#!/bin/bash

# Enable IAM permissions for default service accounts for GKE and Cloud Build

# Fetch Project Number from Project ID:
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")

# Cloud Build SA:
CLOUD_BUILD_SA="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

# GCE SA:
GCE_SA="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"

# 1. Add roles to normal Cloud Build service account
for SUCCINCT_ROLE in \
    artifactregistry.repoAdmin \
    cloudbuild.connectionAdmin \
    cloudbuild.builds.builder \
    clouddeploy.jobRunner \
    clouddeploy.releaser \
    container.developer \
    iam.serviceAccountUser \
    pubsub.subscriber \
    source.reader \
    storage.objectAdmin ; do
  gcloud projects add-iam-policy-binding --member="serviceAccount:${CLOUD_BUILD_SA}" --role "roles/$SUCCINCT_ROLE" "$PROJECT_ID"
done


# 2. Add roles to GCE service account for the GKE nodes (which is usually the default compute account)
for SUCCINCT_ROLE in \
    artifactregistry.admin \
    cloudbuild.connectionAdmin \
    container.developer \
    container.nodeServiceAgent \
    storage.objectCreator \
    ; do
  gcloud projects add-iam-policy-binding --member="serviceAccount:${GCE_SA}" --role "roles/$SUCCINCT_ROLE" "$PROJECT_ID"
done
