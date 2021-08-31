#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

export jwks=$(curl --insecure $(curl --insecure https://k8sou.$hostip.nip.io/auth/idp/k8sIdp/.well-known/openid-configuration 2>/dev/null | jq -r '.jwks_uri') 2>/dev/null | jq -c)

echo $hostip
echo $jwks