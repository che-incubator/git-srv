#!/usr/bin/env bash
#
# Copyright (c) 2022 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

source .././utils.sh
define_namespace

GITLAB_ROUTE="$(oc get route/gitlab --namespace=gitlab-system -o=jsonpath='{.spec.host}')"
unameOut="$(uname -s)"

printf "\nInput the 'Application ID' value from the previous script\n"
read -r APPLICATION_ID
printf "\nInput the 'Secret' value from the previous script\n"
read -r SECRET

case "${unameOut}" in
    Linux*)     BASE64_FUNC='base64 -w 0';;
    Darwin*)    BASE64_FUNC='base64';;
    CYGWIN*)    BASE64_FUNC='base64 -w 0';;
    MINGW*)     BASE64_FUNC='base64 -w 0';;
    *)          BASE64_FUNC='base64 -w 0'
esac

oc project "$NAMESPACE"
#oc delete secret gitlab-oauth-config --ignore-not-found=false

cat <<EOF | oc apply -n "$NAMESPACE" -f -
kind: Secret
apiVersion: v1
metadata:
  name: gitlab-oauth-config
  labels:
    app.kubernetes.io/part-of: che.eclipse.org
    app.kubernetes.io/component: oauth-scm-configuration
  annotations:
    che.eclipse.org/oauth-scm-server: gitlab
    che.eclipse.org/scm-server-endpoint: "https://$GITLAB_ROUTE"
type: Opaque
data:
  id: $(echo -n "$APPLICATION_ID" | $BASE64_FUNC)
  secret: $(echo -n "$SECRET" | $BASE64_FUNC)
EOF
