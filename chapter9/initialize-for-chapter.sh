#!/bin/bash

# first, deploy openunison

cd chapter6/openunison/
./deploy_openunison_imp.sh
cd ../../

# deploy gatekeeper
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/gatekeeper.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/experimental/gatekeeper-mutation.yaml
