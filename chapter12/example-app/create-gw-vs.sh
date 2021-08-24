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
echo -e "Creating VirtualService for the Boutique Workload"
echo -e "*******************************************************************************************************************"
envsubst < gw.yaml | kubectl apply -f - --namespace demo

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating VirtualService for the Boutique Workload"
echo -e "*******************************************************************************************************************"
envsubst < vs.yaml | kubectl apply -f - --namespace demo

tput setaf 5
echo -e "\n\nThe Gateway and VirtualService been ceated"
echo -e "\n\nDue to the networking model of running KinD, we cannot directly hit the VirtualService, so we have created a NGINX"
echo -e "that will forward the requests to the istio-ingressgateway so you can test the application, you can open the UI"
echo -e "using http://demo.$hostip.nip.io/"

echo -e "\n\n"
tput setaf 9
