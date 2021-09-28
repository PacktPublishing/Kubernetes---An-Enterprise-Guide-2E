#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

mkdir /tmp/gitlab-sso-secret

sed "s/IPADDR/$hostip/g" < provider > /tmp/gitlab-sso-secret/provider

kubectl create secret generic gitlab-oidc --from-file=/tmp/gitlab-sso-secret -n gitlab