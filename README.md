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

**ENV Variables**

```
export PROJECT_ID=vps-niantic-demo
export PROJECT_NUMBER=521045629534
export REGION=us-central1
export REGION=us-central1
export ARTIFACT_REPO_NAME=demo

# CLUSTER 1 is DEV
export CLUSTER_NAME1=us-central-demo
export ZONE1=us-central1-c

# CLUSTER 2 is QA
export CLUSTER_NAME2=us-west-demo
export ZONE2=us-west2-c

# CLUSTER 3 is PROD
export CLUSTER_NAME3=us-east-demo
export ZONE2=us-east4-c
```

## 01 - Cloud Build triggers

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
