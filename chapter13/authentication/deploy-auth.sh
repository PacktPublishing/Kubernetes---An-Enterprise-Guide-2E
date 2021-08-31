#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')


echo "getting oidc config"
export oidc_config=$(curl --insecure https://k8sou.$hostip.nip.io/auth/idp/k8sIdp/.well-known/openid-configuration 2>/dev/null | jq -r '.jwks_uri')


echo "getting jwks"
export jwks=$(curl --insecure $oidc_config 2>/dev/null | jq -c '.')

sed "s/IPADDR/$hostip/g" < ./service-auth.yaml | sed "s/JWKS_FROM_SERVER/$jwks/g" > /tmp/service-auth.yaml

kubectl create -f /tmp/service-auth.yaml