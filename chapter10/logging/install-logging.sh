#!/bin/bash
clear

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Installing the ECK Operator and Custom Resources"
echo -e "*******************************************************************************************************************"
tput setaf 2

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Cretaing the Logging namespace"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create ns logging

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Installing the ECK CRDs and Operator"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create -f https://download.elastic.co/downloads/eck/1.7.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.7.0/operator.yaml

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for the Operator to enter a Ready state before creating the Custom Resource"
echo -e "*******************************************************************************************************************"
tput setaf 2
while [ "$(kubectl get pods -l=control-plane='elastic-operator' -n elastic-system -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; 
do
   sleep 5
   echo -e "\nWaiting for the ECK operator to become active."
done

tput setaf 3 
echo -e "\nSuccess... The ECK Operator is Ready, continuing with the deployment of the Custom Resources\n"

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Deploying Elasticsearch, Filebeats and Kibana"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create -f elastic-deploy.yaml
kubectl create -f eck-filebeats.yaml

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Creating the Kibana Ingress Rule"
echo -e "*******************************************************************************************************************"
tput setaf 2
export hostip=$(hostname  -I | cut -f1 -d' ')
envsubst < kibana-ingress.yaml | kubectl create -f - --namespace logging

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Waiting for the Elastic Seach pod to become healthy, this can take a 4-7 minutes"
echo -e "*******************************************************************************************************************"
tput setaf 2
while [ "$(kubectl get pods -l=statefulset.kubernetes.io/pod-name='elasticsearch-es-logging-0' -n logging -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ];
do
   sleep 5
   echo -e "\nWaiting for the ElasticSearch pod to start."
done

tput setaf 3
echo -e "\nSuccess... ElasticSearch is running\n"


export PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -n logging -o go-template='{{.data.elastic | base64decode}}')

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Updating Falcosidekick with the Elasticsearch password to configure ES connectivity"
echo -e "*******************************************************************************************************************"
tput setaf 2
envsubst < values-sidekick-update.yaml | helm upgrade falcosidekick falcosecurity/falcosidekick -f - --namespace falco


tput setaf 6
echo -e "\n*******************************************************************************************************************"
echo -e "ECK and all Custom Resources have been deployed"
echo -e "*******************************************************************************************************************"
echo -e "\nThe Kibana UI has been added to ingress, you can open the UI using http://kibana.$hostip.nip.io/"
echo -e "To log into Kibana, you will need to use the following credentials:\n"
echo -e "*******************************************************************************************************************"
echo -e "  Username: elastic  "
echo -e "  Password: $PASSWORD"
echo -e "*******************************************************************************************************************\n\n"

tput setaf 9
