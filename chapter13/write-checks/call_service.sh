#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

curl  -H "Authorization: Bearer $(curl --insecure -u 'mmosley:start123' https://k8sou.$hostip.nip.io/get-user-token/token/user 2>/dev/null| jq -r '.token.id_token')" http://write-checks.$hostip.nip.io/write-check  2>/dev/null  | jq -r