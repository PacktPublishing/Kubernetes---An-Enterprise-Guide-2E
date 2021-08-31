#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')
export hostip="192-168-2-119"

echo "getting oidc config"
export oidc_config=$(curl --insecure https://k8sou.$hostip.nip.io/auth/idp/k8sIdp/.well-known/openid-configuration 2>/dev/null | jq -r '.jwks_uri')
echo $oidc_config

echo "getting jwks"
export jwks=$(curl --insecure $oidc_config 2>/dev/null | jq -c)

echo $hostip
echo $jwks