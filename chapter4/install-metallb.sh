#!/bin/bash
clear

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Installing MetalLB"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Configuring MetalLB IP Pool"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl apply -f metallb-config.yaml

tput setaf 3
echo -e "\n*******************************************************************************************************************"
echo -e "MetalLB installation complete"
echo -e "*******************************************************************************************************************\n"
tput setaf 2

kubectl get pods -n metallb-system

echo -e "\n\n"
