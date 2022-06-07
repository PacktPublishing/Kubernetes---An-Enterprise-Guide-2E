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
echo -e "Deploying DNSmasq Container to main NIC IP (default)"
echo -e "*******************************************************************************************************************"
tput setaf 3

docker run --name dnsmasq -d -p 10.2.1.67:53:53/udp -p 10.2.1.67:53:53/tcp -p 10.2.1.67:8080:8080 -v $PWD/dnsmasq.conf:/etc/dnsmasq.conf --log-opt "max-size=100m" -e "HTTP_USER=admin" -e "HTTP_PASS=admin" --restart always jpillora/dnsmasq

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating two KinD Clusters"
echo -e "*******************************************************************************************************************"
tput setaf 3

./install-kind.sh
./create-kind-cluster.sh


