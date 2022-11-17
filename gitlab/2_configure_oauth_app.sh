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

FORMATTED_NAMESPACE="$(echo "$NAMESPACE" | sed 's/.*-//')"
CHE_ROUTE="$(oc get route/"$FORMATTED_NAMESPACE" --namespace="$NAMESPACE" -o=jsonpath='{.spec.host}')"
GITLAB_ROUTE="$(oc get route/gitlab --namespace=gitlab-system -o=jsonpath='{.spec.host}')"
CHE_SERVER_URL="https://${CHE_ROUTE}"
GITLAB_APP_URL="https://$GITLAB_ROUTE/-/profile/applications"

echo '     '
echo '     '
echo " Open $GITLAB_APP_URL"
echo '     '
echo '     '
echo " Fill in the next values:"
echo " Name:              $FORMATTED_NAMESPACE"
echo " Redirect URI:      $CHE_SERVER_URL/api/oauth/callback"
echo " Under Scopes, check the api, write_repository, and openid checkboxes."
echo '     '
echo " Press the 'Save application' button."
echo " Save the 'Application ID' and 'Secret' values for the further actions."

