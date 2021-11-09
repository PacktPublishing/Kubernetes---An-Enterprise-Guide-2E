#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying the Gateway and VirtualService for the Boutique example application"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Getting the Host IP address to create the nip.ip name"
echo -e "*******************************************************************************************************************"
export hostip=$(hostname  -I | cut -f1 -d' ')

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Gateway for the Boutique Workload"
echo -e "*******************************************************************************************************************"
envsubst < gw.yaml | kubectl apply -f - --namespace demo

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating VirtualService for the Boutique Workload"
echo -e "*******************************************************************************************************************"
envsubst < vs.yaml | kubectl apply -f - --namespace demo

tput setaf 5
echo -e "\n \nIt may take 3-5 minutes for the application pods to become ready"
echo -e "\n \nOnce all pods are running, the Boutique application can be accessed using using http://demo.$hostip.nip.io/"

echo -e "\n\n"
tput setaf 9
