#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying the Gateway and VirtualService for Kiali"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Getting the Host IP address to create the nip.ip name"
echo -e "*******************************************************************************************************************"
export hostip=$(hostname  -I | cut -f1 -d' ')

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Gateway for Kiali"
echo -e "*******************************************************************************************************************"
envsubst < gw.yaml | kubectl apply -f - 

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating VirtualService for Kiali"
echo -e "*******************************************************************************************************************"
envsubst < vs.yaml | kubectl apply -f - 

tput setaf 5
echo -e "The Kiali Istio objects have been created, you can open the UI using http://kiali.$hostip.nip.io/"

echo -e "\n\n"
tput setaf 9
