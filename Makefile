SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Source important environmental variables that need to be persisted and are easy to forget about
-include .env

authenticate:
	@gcloud auth application-default login

source-env:
	@sh ./scripts/source-env.sh

enable-apis:
	@gcloud --project prj-zeld-deku services enable \
		artifactregistry.googleapis.com \
		cloudbuild.googleapis.com \
		clouddeploy.googleapis.com \
		cloudresourcemanager.googleapis.com \
		compute.googleapis.com \
		container.googleapis.com

enable-iam:
	@sh ./scripts/enable-iam.sh

# This is where local builds should go. Those not going through deployment
# pipeline
registry-dirty:
	@gcloud artifacts repositories create ${ARTIFACT_REPO_NAME}-dirty \
  	--repository-format=docker \
  	--location=${REGION} \
		--labels=env=local,status=dirty \
  	--description="Docker cicd demo repository for local development"

registry:
	@gcloud artifacts repositories create ${ARTIFACT_REPO_NAME} \
  	--repository-format=docker \
  	--location=${REGION} \
		--labels=env=demo,status=clean \
  	--description="Docker cicd demo repository"

build-trigger-main:
	@gcloud beta builds triggers create cloud-source-repositories \
		--name="csr-branch-be00" \
		--description="Trigger from CSR on main branch for apps/backend00" \
		--region=${REGION} \
		--repo=${CSR_REPO_NAME} \
		--branch-pattern="^main$$" \
		--build-config=cloudbuild.yaml \
		--included-files="apps/backend00/**,cloudbuild.yaml,skaffold.yaml" \
		--substitutions=_DEPLOY_PIPELINE=backend00

build-trigger-tag:
	@gcloud beta builds triggers create cloud-source-repositories \
		--name="csr-tag-be00" \
		--description="Trigger from CSR on version release for apps/backend00" \
		--region=${REGION} \
		--repo=${CSR_REPO_NAME} \
		--tag-pattern=v* \
		--build-config=cloudbuild.yaml \
		--included-files="apps/backend00/**,cloudbuild.yaml,skaffold.yaml" \
		--substitutions=_DEPLOY_PIPELINE=backend00

build-be00:
	@gcloud builds submit --region=${REGION} \
		--tag ${REGION}-docker.pkg.dev/prj-zeld-deku/${ARTIFACT_REPO_NAME}/be00:latest \
		./apps/backend00

build-dirty-be00:
	@gcloud builds submit --region=${REGION} \
		--tag ${REGION}-docker.pkg.dev/prj-zeld-deku/${ARTIFACT_REPO_NAME}-dirty/be00:latest \
		./apps/backend00

deploy-pipeline:
	@gcloud --project ${PROJECT_ID} deploy apply --file clouddeploy.yaml --region "${REGION}"

asm-install:
	@curl https://storage.googleapis.com/csm-artifacts/asm/asmcli > asmcli
	@chmod +x asmcli
	@./asmcli install \
  	--project_id ${PROJECT_ID} \
  	--cluster_name ${CLUSTER_PROD_NAME} \
  	--cluster_location ${CLUSTER_PROD_LOC} \
  	--fleet_id ${PROJECT_ID} \
		--managed \
		--channel stable \
  	--output_dir ./tmp \
  	--enable_all \
  	--ca mesh_ca
	@kubectl label namespace istio-system \
		istio-injection=enabled istio.io/rev=asm-managed-stable \
		--overwrite
	@kubectl apply -n istio-system -f tmp/samples/gateways/istio-ingressgateway
	@rm ./asmcli
	@rm -rf tmp
