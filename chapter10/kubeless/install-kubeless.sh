#!/bin/bash
clear

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Chapter 10 - Installing Kubeless"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creting Kubeless namespace"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create ns kubeless

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying Kubeless"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create -f kubeless-v1.0.8.yaml -n kubeless

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Service Account and ClusterRoleBinding for Falco Functions"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create sa falco-functions -n kubeless
# This is not recommended in Production - We have granted Cluster-Admin to make the integration easier for the book
kubectl create clusterrolebinding falco-functions --clusterrole=cluster-admin --serviceaccount=kubeless:falco-functions

tput setaf 3
echo -e "\n \n*******************************************************************************************************************"
echo -e "Kubless installation completed"
echo -e "*******************************************************************************************************************"
tput setaf 2

echo -e "\n\n"
