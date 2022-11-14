#!/usr/bin/env bash

if [[ $(kubectl get pods -n eclipse-che 2> /dev/null | wc -l) -gt 0 ]]
then
  NAMESPACE="eclipse-che"
else
  NAMESPACE="openshift-devspaces"
fi

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
echo " Fil in the next values:"
echo " Name:              $FORMATTED_NAMESPACE"
echo " Redirect URI:      $CHE_SERVER_URL/api/oauth/callback"
echo " Under Scopes, check the api, write_repository, and openid checkboxes."
echo '     '
echo " Press the 'Save application' button."
echo " Save the 'Application ID' and 'Secret' values for the further actions."

