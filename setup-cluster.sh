#!/bin/bash
set -e

project='favour-cicd'
profile='favour-cicd'
environment='local'

# Logo

imgcat assets/logo.jpg --width 100

# Running inside docker

if ! [ -f "/.dockerenv" ]
then
    echo "Error: This script must be run inside a docker container"
    exit 1
fi

# Is docker in docker running?

docker version --format {{.Server.Os}}-{{.Server.Version}}:{{.Server.Platform.Name}}

if ! [ $? -eq 0 ] 
			then 
	echo "Error: Docker is not running, restart Docker Desktop or rebuild your devcontainer." >&2 
  exit 1 
fi

# Validate required environment variables


declare -a requireds=("GITHUB_USER" "GITHUB_TOKEN" "GITHUB_EMAIL")


for required in ${requireds[@]}; do
  if [ -z "${!required}" ]; then
    echo "Error: Environment variable $required is not set"
    exit 1
  fi
done

#  Get some secrets
# to use impersonation, set the argument Impersonate to the name of the service account you would like to impersonate 
# pwsh scripts/retrieve-secrets.ps1 -Project $project -Secret 'favour-cicd-local' -Impersonate 'terraform-reader'

pwsh scripts/retrieve-secrets.ps1 -Project $project -Secret 'favour-cicd-local'

source /tmp/secrets.sh

# Add secrets

requireds+=("GSA_KEY")

# Destroy minikube

minikube delete -p $profile

# Start minikube

minikube start --profile $profile  --memory=8192 --cpus=4

# minikube addons

minikube addons enable registry --profile $profile

# run socat for relaying the docker registry

docker run --detach --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip -p $profile):5000"

{
    # Copy the files to a temp folder

    mkdir /tmp/deploy

    cp -R ./environments /tmp/deploy

    # Do some token replacement
    for required in ${requireds[@]}; do
      echo "Processing $required..."

      value=$(printf "%s" "${!required}")

      pwsh scripts/token-replacement.ps1 -Path /tmp/deploy/ -Find "#${required}#" -Replace "${value}"
      
      value64=$(printf "%s" "${value}" | base64 -i -w 0)
      sed -i "s/#b64enc(${required})#/${value64}/g" $(find /tmp/deploy/ -type f)
    done

    sed -i "s/#ENVIRONMENT#/${environment}/g" $(find /tmp/deploy/ -type f)

    # Apply argocd manifests

    kubectl create ns argocd

    kubectl apply -f /tmp/deploy/environments/bootstrap/argocd.yaml

    # Apply the bootstrap manifests

    kubectl apply -k /tmp/deploy/environments/bootstrap

    # Remove temp files
    rm -rf /tmp/deploy/
} || {
    # Remove temp files
    rm -rf /tmp/deploy/
}

# favour-cicd namespace

kubectl create ns $profile

# artifact registry pull secret

kubectl create secret docker-registry gar-image-pull --docker-server=europe-west1-docker.pkg.dev --docker-username=_json_key --docker-password="$(echo $GSA_KEY | base64 --decode)" --docker-email=noreply@invalid.tld -n $profile 
kubectl create secret docker-registry gar-image-pull --docker-server=europe-west1-docker.pkg.dev --docker-username=_json_key --docker-password="$(echo $GSA_KEY | base64 --decode)" --docker-email=noreply@invalid.tld -n argocd  

minikube tunnel --cleanup --profile $profile &

# Add Helm repos

helm repo add argo https://argoproj.github.io/argo-helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo add external-secrets https://charts.external-secrets.io
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stakater https://stakater.github.io/stakater-charts