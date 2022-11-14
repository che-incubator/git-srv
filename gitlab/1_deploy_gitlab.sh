#!/usr/bin/env bash

wait-pod-running() {
	[[ -z $1 ]] && { echo '[ERROR] SELECTOR not defined'; exit 1; }
	[[ -z $2 ]] && { echo '[ERROR] NAMESPACE not defined'; exit 1; }

	while [ "$(kubectl get pod -l "$1" -n "$2" -o go-template='{{len .items}}')" -eq 0 ]; do
  		sleep 10
  	done
  	kubectl wait --for=condition=ready pod -l "$1" -n "$2" --timeout=120s
}

# Install cer-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
wait-pod-running "app.kubernetes.io/component=controller" "cert-manager"
wait-pod-running "app.kubernetes.io/component=cainjector" "cert-manager"
wait-pod-running "app.kubernetes.io/component=webhook" "cert-manager"

# Install gitlab
kubectl create namespace gitlab-system
kubectl apply -f https://gitlab.com/api/v4/projects/18899486/packages/generic/gitlab-operator/0.13.3/gitlab-operator-openshift-0.13.3.yaml
wait-pod-running "control-plane=controller-manager" "gitlab-system"

# Prepare gitlab instance
HOSTNAME="$(kubectl get route -n openshift-console console -ojsonpath='{.status.ingress[0].host}')"
TRIMMED_HOSTNAME="${HOSTNAME:26}"
DOMAIN="$TRIMMED_HOSTNAME" envsubst < gitlab_template.yaml > gitlab.yaml
kubectl -n gitlab-system apply -f gitlab.yaml
rm gitlab.yaml
printf "\n\nWaiting for Gitlab to start, it may take more than 10 minutes.\n\n"
wait-pod-running "app.kubernetes.io/component=webservice" "gitlab-system"

# Apply gitlab route
oc create route edge gitlab --service=gitlab-webservice-default --port=http-workhorse -n gitlab-system
printf "Gitlab has started, visit https://gitlab-gitlab-system.%s.\n\n" "$TRIMMED_HOSTNAME"

PASSWORD="$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab-system -o jsonpath="{.data.password}" | base64 --decode)"
printf "login: root\nPassword: %s\n\n" "$PASSWORD"
