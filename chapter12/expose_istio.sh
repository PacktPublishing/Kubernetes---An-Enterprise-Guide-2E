#!/bin/bash

clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deleting ingress-nginx namespace"
echo -e "*******************************************************************************************************************"

kubectl delete ns ingress-nginx

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Patching istio-ingressgateway"
echo -e "*******************************************************************************************************************"

kubectl patch deployments istio-ingressgateway -n istio-system -p '{"spec":{"template":{"spec":{"containers":[{"name":"istio-proxy","ports":[{"containerPort":15021,"protocol":"TCP"},{"containerPort":8080,"hostPort":80,"protocol":"TCP"},{"containerPort":8443,"hostPort":8443,"protocol":"TCP"},{"containerPort":31400,"protocol":"TCP"},{"containerPort":15443,"protocol":"TCP"},{"containerPort":15090,"name":"http-envoy-prom","protocol":"TCP"}]}]}}}}'
