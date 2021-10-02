#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating objects for Velero tests"
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Demo Namespaces"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create ns demo1
kubectl create ns demo2
kubectl create ns demo3
kubectl create ns demo4

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Objects in each namespace"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl run nginx --image=bitnami/nginx -n demo1
kubectl run nginx --image=bitnami/nginx -n demo2
kubectl run nginx --image=bitnami/nginx -n demo3
kubectl run nginx --image=bitnami/nginx -n demo4

echo -e "\n"
tput setaf 9
