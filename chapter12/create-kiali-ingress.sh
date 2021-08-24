#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying the Ingress Rule for Kiali"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Ingress rule for Kiali"
echo -e "*******************************************************************************************************************"
tput setaf 2
export hostip=$(hostname  -I | cut -f1 -d' ')
envsubst < kiali-ingress.yaml | kubectl apply -f - --namespace istio-system

tput setaf 5
echo -e "\n\nThe Kiali ingress rule has been ceated, you can open the UI using http://kiali.$hostip.nip.io/"

echo -e "\n\n"
tput setaf 9
