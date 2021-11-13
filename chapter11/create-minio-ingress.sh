#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying the Ingress Rule for the Velero Dashboard"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Ingress rule for the Velero Dashboard"
echo -e "*******************************************************************************************************************"
tput setaf 2
export hostip=$(hostname  -I | cut -f1 -d' ')
envsubst < minio-ingress.yaml | kubectl apply -f - --namespace velero

tput setaf 5
echo -e "\n\nThe Minio dashboard ingress rule has been ceated, you can open the UI using http://minio-console.$hostip.nip.io/"

echo -e "\n\n"
tput setaf 9
