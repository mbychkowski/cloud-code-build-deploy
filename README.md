# Local Developement Lifecycyl & CI/CD Demo

This repository touches on the following services from Google Cloud and Open
Source.

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

>This is not an officially supported Google repository.  All code and assets
>provided in this repo are made available on an as-is basis and the end user is
>responsible for all of their own security, scaling, and cost control as part of
>this deployment.

## 00 - Initialize

For demonstration purposes it is recommended to set this code up in a
[Cloud Source Repository](https://source.cloud.google.com/) in your Goolge Cloud
project. Push this repository to that.

**ENV Variables**

Define environment variables in terminal

```
export REGION=us-central1 # e.g. us-central1
export ARTIFACT_REPO_NAME="cicd" # e.g. "cicd"
export CSR_REPO_NAME="cicd-demo" # e.g. "cicd-demo"

export CLUSTER_DEV_NAME=gke-dev       # change as needed
export CLUSTER_DEV_LOC=us-central1-c  # change as needed

export CLUSTER_PROD_NAME=gke-qa       # change as needed
export CLUSTER_PROD_LOC=us-central1-c # change as needed
```

And source environment variables to be available for Makefile and else where

```
. ./scripts/source-env.sh
```

If running into trouble with IAM issues or APIs not enabled run the following
commands:

```
make enable-apis
make enable-iams
```

At any point you can also check out the Makefile directly to run the commands
without Make.

## 01 - Create Artifact Registry

We will create a "dirty" Artifact Registry and a "clean" registry. The "dirty"
registry will be for all of our local builds and development and the "clean"
registry will be for anything pushed to the deployment pipeline.

Create the dirty Artifact Registry with `Makefile`:

```
make registry-drity
```

and clean registry:

```
make registry
```

Verify successful creation:

```
gcloud artifacts repositories list
```

Output should include our new registries: `$ARTIFACT_REPO_NAME` and
`$ARTIFACT_REPO_NAME-dirty`.

The "dirty" registry will tag the images in the format
`dev_"2006-01-02_15-04-05.999_MST"` that can be viewed in the `skaffol.yaml` in
`apps/backend00/skaffold.yaml` directory.

## 02 - Cloud Build triggers

Create the Cloud Build triggers for our backend app, `backend00`. To create
trigger based on `push` to `Main` branch:

```
make build-trigger-main
```

To create a trigger based on a release via a `tag` with the name `v*` run:

```
make build-trigger-tag
```

## 03 - Cloud Code

Make sure you have [Cloud Code](https://cloud.google.com/code/docs/vscode/install)
installed.

Click on "Run on Kubernetes" and walk through the setup to connect your `dev`
cluster and the "dirty" Artifact Registry. If using VSCode, this will create a
`launch.json` file with the configs.

![cloud code run on kubernetes](./docs/assets/cloud_code_start.png)

## 04 - Cloud Deploy

```
gcloud --project $PROJECT_ID deploy apply --file clouddeploy.yaml --region "$REGION"
```
