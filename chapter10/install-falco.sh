#!/bin/bash
clear

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Installing Falco..."
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creting Falco namespace"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create ns falco

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding Falco Charts to Helm Repo"
echo -e "*******************************************************************************************************************"
tput setaf 2
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying Falco with EBPF enabled"
echo -e "*******************************************************************************************************************"
tput setaf 2
helm install falco falcosecurity/falco -f values-falco.yaml -f custom-nginx.yaml --namespace falco


tput setaf 3
echo -e "\n \n*******************************************************************************************************************"
echo -e "Falco deployment complete - Verify that the Falco pod has been created in the Falco namespace and that its running"
echo -e "*******************************************************************************************************************"
tput setaf 2

echo -e "\n\n"
