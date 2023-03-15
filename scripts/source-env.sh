#!/bin/bash

if [ -f .env ]; then
  rm .env
fi

if [[ -f cloud*.yaml ]]; then
  rm cloud*.yaml
fi

cp ./templates/.env .env
cp ./templates/cloudbuild.yaml cloudbuild.yaml
cp ./templates/clouddeploy.yaml clouddeploy.yaml

cp ./apps/backend00/templates/skaffold.yaml apps/backend00/skaffold.yaml
cp ./apps/backend00/templates/image-repo-local-patch.yaml apps/backend00/k8s/overlays/local/image-repo-local-patch.yaml
cp ./apps/backend00/templates/deploy.yaml apps/backend00/k8s/base/deploy.yaml

PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)

PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")

# Replace environment variables with specific values for necessary templates
while read line; do
  ENV_VAR=$(sed -e 's/export \(.*\)=.*/\1/' <<< ${line})

  if [[ $line != "" ]] && [[ $line != "#"* ]]; then
    echo "$ENV_VAR | ${!ENV_VAR}"
    find ./ -type f \( -iname \*.env -o -iname \*.yaml \) \
      ! -path '*/templates/*' ! -path '*/scripts/*' \
      -exec sed -i 's\${'"$ENV_VAR"'}\'"${!ENV_VAR}"'\g' {} +
  fi

done < ./templates/.env
