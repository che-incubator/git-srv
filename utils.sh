#!/usr/bin/env bash
#
# Copyright (c) 2022 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

define_namespace() {
   if [[ $(kubectl get pods -n eclipse-che 2> /dev/null | wc -l) -gt 0 ]]
   then
     export NAMESPACE="eclipse-che"
   elif [[ $(kubectl get pods -n openshift-devspaces 2> /dev/null | wc -l) -gt 0 ]]
   then
     export NAMESPACE="openshift-devspaces"
   else
     echo "Che / devspaces not found in the Openshift cluster!"
     exit 0
   fi
}
