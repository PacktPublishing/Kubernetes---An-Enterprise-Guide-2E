#!/bin/bash
clear

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Kubernetes: An Enterprise Guide"
echo -e "Excursion : Multi-Cluster Kubernetes using KinD"
echo -e "*******************************************************************************************************************"
tput setaf 3

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Reading Environment Variables"
echo -e "*******************************************************************************************************************"
tput setaf 3

. ./envars.sh

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Cluster Configuration Files and DNSmasq Configration file from the Environment Variables"
echo -e "*******************************************************************************************************************"
tput setaf 3

envsubst < cluster1-template.yaml > cluster1.yaml
envsubst < cluster2-template.yaml > cluster2.yaml
envsubst < dnsmasq-template.conf > dnsmasq.conf

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating new Network Configuration File"
echo -e "*******************************************************************************************************************"
tput setaf 3

envsubst < network-template.conf > 00-installer-config.yaml
sudo rm /etc/netplan/00-installer-config.yaml
sudo mv 00-installer-config.yaml /etc/netplan/00-installer-config.yaml
sudo netplan apply


tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying DNSmasq Container to main NIC First IP"
echo -e "*******************************************************************************************************************"
tput setaf 3

docker run --name dnsmasq -d -p $nic_ip1:53:53/udp -p $nic_ip1:53:53/tcp -p $nic_ip1:8080:8080 -v $PWD/dnsmasq.conf:/etc/dnsmasq.conf --log-opt "max-size=100m" -e "HTTP_USER=admin" -e "HTTP_PASS=admin" --restart always jpillora/dnsmasq

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Setting the Local Server DNS resolve.conf file"
echo -e "*******************************************************************************************************************"
tput setaf 3

sudo rm -f /etc/resolv.conf
envsubst < resolv-template.conf > resolv.conf
sudo mv resolv.conf /etc/resolv.conf

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating two KinD Clusters"
echo -e "*******************************************************************************************************************"
tput setaf 3

./install-kind.sh
./create-kind-cluster.sh

