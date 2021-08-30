#!/bin/bash

echo "Deleting old Kiali VirtualService and Gateway"
kubectl delete gateway kiali-gateway -n istio-system
kubectl delete virtualservice kiali-vs -n istio-system

echo "Update Kiali to use auth header"

helm upgrade --namespace istio-system --set auth.strategy="header" --repo https://kiali.org/helm-charts kiali-server kiali-server
kubectl delete pods -l app=kiali -n istio-system

echo "Configure OpenUnison for Kiali"

if [[ -z "${TS_REPO_NAME}" ]]; then
        REPO_NAME="tremolo"
else
        REPO_NAME=$TS_REPO_NAME
fi

echo "Helm Repo Name $REPO_NAME"

helm install openunison-kiali $REPO_NAME/openunison-kiali -f ./openunison-kiali-values.yaml -n openunison

echo "Login to OpenUnison to access Kiali"
