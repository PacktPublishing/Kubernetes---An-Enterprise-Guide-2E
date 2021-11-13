#!/bin/bash

clear
tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Downloading etcdctl and extracting contents"
echo -e "*******************************************************************************************************************"
tput setaf 2
wget https://github.com/etcd-io/etcd/releases/download/v3.5.1/etcd-v3.5.1-linux-amd64.tar.gz
tar xvf etcd-v3.5.1-linux-amd64.tar.gz

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Moving the KinD Binary to /usr/bin"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo cp etcd-v3.5.1-linux-amd64/etcdctl /usr/bin

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Removing archive and extra files"
echo -e "*******************************************************************************************************************"
tput setaf 2
rm etcd-v3.5.1-linux-amd64.tar.gz
rm -rf etcd-v3.5.1-linux-amd64

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Copying the etcd certificates from the control plane into the ./certs directory"
echo -e "*******************************************************************************************************************"
tput setaf 2

docker cp cluster01-control-plane:/etc/kubernetes/pki/etcd ./certs

tput setaf 3
echo -e "\n*******************************************************************************************************************"
echo -e "etcdctl download complete"
echo -e "*******************************************************************************************************************"
tput setaf 2

