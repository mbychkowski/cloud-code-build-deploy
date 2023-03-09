# Local Developement Lifecycyl & CI/CD Demo

* More detailed docs coming soon

**Google Cloud**
- Cloud Code
- Cloud Build
- Pub/Sub
- Artifact Registry
- Cloud Deploy
- ASM (traffic splitting)

**Open Source**
- Skaffold
- Kustomize
- Helm (TODO)

## 00 - Initialize

For demonstration purposes it is recommended to set this code up in a Cloud Source Repository in your project. Search "Source Repository" in cloud console and configure new one. Push this repository to that.

**ENV Variables**

Define environment variables in terminal

```
export REGION=us-central1 # e.g. us-central1
export ARTIFACT_REPO_NAME="cicd" # e.g. "cicd"
export CSR_REPO_NAME="cicd-demo" # e.g. "cicd-demo"

# CLUSTER 1 is DEV
export CLUSTER_NAME1=gke-dev  # change as needed
export ZONE1=us-central1-c    # change as needed

# CLUSTER 2 is QA
export CLUSTER_NAME2=gke-qa   # change as needed
export ZONE2=us-central1-c    # change as needed

# CLUSTER 3 is PROD
export CLUSTER_NAME3=gke-prod # change as needed
export ZONE3=us-central1-c    # change as needed
```

And source environment variables to be available for Makefile and else where

```
make source-env
```

If running into trouble with IAM issues or APIs not enabled run the following commands:

```
make enable-apis
make enable-iams
```

At any point you can also check out the Makefile directly to run the commands without Make.

## 01 - Create Artifact Registry

Create the Artifact Registry with `Makefile`:

```
make registry
```

or straight `gcloud` command:

```
gcloud artifacts repositories create $ARTIFACT_REPO_NAME \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker cicd demo repository"
```

## 02 - Cloud Build triggers

```
e.g.
be-py | backend00  | "backend/**,*.yaml"  |
fe-js | frontend00 | "frontend/**,*.yaml" |

APP_ID="be-py"
APP_NAME="backend00"
APP_SUBFOLDER="backend/**,*.yaml"
SUBSTITUTIONS=_DEPLOY_UNIT=$APP_NAME,_REGION=$REGION,_ARTIFACT_REPONAME=$ARTIFACT_REPONAME
```

```
AR_REGION=us-central1
AR_PROJECT_ID=prj-zeld-deku
AR_REPO_NAME=https://source.developers.google.com/p/prj-zeld-deku/r/devops-simple
AR_IMAGE_NAME=backend00
CODE_REPO_NAME=devops-simple
CODE_BRANCH_NAME=main
SUBSTITUTIONS=_IAMGE_TAG="'$(body.message.data.tag)',_ACTION_='$(body.message.data.action)'"
```

Push image to Artifact Registry

```
gcloud builds submit --region=$AR_REGION --tag $AR_REGION-docker.pkg.dev/$AR_PROJECT_ID/$AR_REPO_NAME/$AR_IMAGE_NAME:latest .
```

## 02 - Cloud Deploy

```
gcloud --project $PROJECT_ID deploy apply --file clouddeploy.yaml --region "$REGION"
```
