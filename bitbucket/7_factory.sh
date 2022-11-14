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
BITBUCKET_ROUTE=$(oc get route/bitbucket --namespace=bitbucket -o=jsonpath={'.spec.host'})
echo 'Using Eclipse Che namespace: '$NAMESPACE
echo 'Using Eclipse Che route: '$CHE_SERVER_URL
echo 'Using Eclipse KEYCLOAK route: '$KEYCLOAK_ROUTE
echo 'Using Eclipse KEYCLOAK url: '$KEYCLOAK_URL
echo 'Bitbucket url: '$BITBUCKET_ROUTE
#echo 'KC token: '$KEYCLOAK_TOKEN
echo '======='

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OPEN_FUNC=xdg-open;;
    Darwin*)    OPEN_FUNC=open;;
    CYGWIN*)    OPEN_FUNC=xdg-open;;
    MINGW*)     OPEN_FUNC=xdg-open;;
    *)          OPEN_FUNC=xdg-open
esac

$OPEN_FUNC $CHE_SERVER_URL'/f?url=https://'$BITBUCKET_ROUTE'/scm/che/che-server.git'
