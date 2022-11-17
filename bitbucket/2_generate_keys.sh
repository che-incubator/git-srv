#!/usr/bin/env bash
#
# Copyright (c) 2022 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

rm -rf ./certs
mkdir certs
openssl genrsa -out ./certs/private.pem 2048
openssl rsa -in ./certs/private.pem -pubout > ./certs/public.pub
openssl pkcs8 -topk8 -inform pem -outform pem -nocrypt -in ./certs/private.pem -out ./certs/privatepkcs8.pem 
openssl rand -base64 24 > ./certs/bitbucket_server_consumer_key
openssl rand -base64 24 > ./certs/bitbucket_shared_secret
