#!/bin/bash

tput setaf 5
#Install kubectl
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 1: Install kubectl"
echo -e "*******************************************************************************************************************"
tput setaf 3
#sudo snap install kubectl --classic
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

tput setaf 5
#install helm and jq
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 2: Install Helm3 and jq"
echo -e "*******************************************************************************************************************"
tput setaf 3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

sudo snap install jq --classic

tput setaf 5
#Create KIND Cluster calle cluster01 using config cluster01-kind.yaml
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 3: Creating the first KinD Cluster"
echo -e "*******************************************************************************************************************"
tput setaf 3
/usr/bin/kind create cluster --name cluster1 --config cluster1.yaml

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 4: Adding node label for Ingress Controller to worker node - Cluster1"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl label node test-cluster01-worker ingress-ready=true

#Install Calico
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 5: Install Calico from local file, using 10.240.0.0/16 as the pod CIDR"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl create -f calico.yaml

#Deploy NGINX
tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 6: Install NGINX Ingress Controller"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl create -f nginx-deploy.yaml

tput setaf 5
#Create KIND Cluster calle cluster01 using config cluster01-kind.yaml
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 7: Creating the Second KinD Cluster"
echo -e "*******************************************************************************************************************"
tput setaf 3
/usr/bin/kind create cluster --name cluster2 --config cluster2.yaml

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 8: Adding node label for Ingress Controller to worker node - Cluster02"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl label node test-cluster02-worker ingress-ready=true

#Install Calico
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 9: Install Calico from local file, using 10.240.0.0/16 as the pod CIDR"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl create -f calico.yaml

#Deploy NGINX
tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 10: Install NGINX Ingress Controller"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl create -f nginx-deploy.yaml

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 11: Setting the config context to Cluster01"
echo -e "*******************************************************************************************************************"
tput setaf 3

kubectl config use-context kind-test-cluster01

#Find IP address of Docker Host
tput setaf 3
hostip=$(hostname  -I | cut -f1 -d' ')
echo -e "\n \n*******************************************************************************************************************"
echo -e "Cluster Creation Complete.  Please see the summary below for key information that will be used in later chapters"
echo -e "*******************************************************************************************************************"

tput setaf 7
echo -e "\n \n*******************************************************************************************************************"
echo -e "Your Kind Cluster(s) Information: \n\n"
echo -e "Ingress Domains:"
echo -e "----------------"
echo -e "Domain Name1: $dns_domain1 on IP Address: $nic_ip2"
echo -e "Domain Name2: $dns_domain2 on IP Address: $nic_ip3"
echo -e "\n"
echo -e "DNmasq IP Address : $nic_ip1 on NIC $main_nic"
echo -e "******************************************************************************************************************* \n"
