Scripts to deploy Gitlab to an Openshift cluster and set up an oAuth app.

* 1_deploy_gitlab.sh - deploys Gitlab to an Openshift cluster.
* 2_configure_oauth_app.sh - prints instructions to set up Gitlab oAuth app.
* 3_setup_oauth_secret.sh - applies oAuth configuration to che/devspaces.

Prerequisites:
* kubectl, oc
* Authorised oc connection to an Openshift cluster
