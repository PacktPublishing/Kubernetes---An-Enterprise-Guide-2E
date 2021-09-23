#!/bin/bash

mkdir -p ssl


openssl genrsa -out ssl/tls.key 2048
openssl req -x509 -new -nodes -key ssl/tls.key -days 3650 -sha256 -out ssl/tls.crt -subj "/CN=internal-ca"


