#!/usr/bin/env bash

if [[ $(kubectl get pods -n eclipse-che 2> /dev/null | wc -l) -gt 0 ]]
then
  NAMESPACE="eclipse-che"
else
  NAMESPACE="openshift-devspaces"
fi
oc project $NAMESPACE
CHE_ROUTE=$(oc get route/che --namespace=$NAMESPACE -o=jsonpath={'.spec.host'})
CHE_SERVER_URL='https://'${CHE_ROUTE}
KEYCLOAK_ROUTE=$(oc get route/keycloak --namespace=$NAMESPACE -o=jsonpath={'.spec.host'})
KEYCLOAK_URL='https://'${KEYCLOAK_ROUTE}
OS_TOKEN=$(oc whoami --show-token)
echo 'Using Eclipse Che namespace: '$NAMESPACE
echo 'Using Eclipse Che route: '$CHE_SERVER_URL
echo 'Using Eclipse KEYCLOAK route: '$KEYCLOAK_ROUTE
echo 'Using Eclipse KEYCLOAK url: '$KEYCLOAK_URL

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OPEN_FUNC=xdg-open;;
    Darwin*)    OPEN_FUNC=open;;
    CYGWIN*)    OPEN_FUNC=xdg-open;;
    MINGW*)     OPEN_FUNC=xdg-open;;
    *)          OPEN_FUNC=xdg-open
esac

KEYCLOAK_TOKEN=$(curl -s -X POST -d "client_id=che-public" \
     --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
      -d "subject_token=$OS_TOKEN" \
      -d "subject_issuer=openshift-v4" \
     --data-urlencode "subject_token_type=urn:ietf:params:oauth:token-type:access_token" \
  $KEYCLOAK_URL/auth/realms/che/protocol/openid-connect/token | jq -j .access_token)
#echo 'KC token: '$KEYCLOAK_TOKEN
echo '======='
USER_ID=$(curl -s  $CHE_SERVER_URL/api/user  -H 'Accept: application/json, text/plain'  -H 'Authorization: Bearer '${KEYCLOAK_TOKEN}  | jq -r .id)
echo 'Click the link'
echo 'url: '$CHE_SERVER_URL'/api/oauth/1.0/authenticate?oauth_provider=bitbucket-server&request_method=POST&signature_method=rsa&redirect_after_login=/dashboard&token='$KEYCLOAK_TOKEN
$OPEN_FUNC $CHE_SERVER_URL'/api/oauth/1.0/authenticate?oauth_provider=bitbucket-server&request_method=POST&signature_method=rsa&redirect_after_login=/dashboard&token='$KEYCLOAK_TOKEN
