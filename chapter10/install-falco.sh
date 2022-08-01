#!/bin/bash
clear

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Installing Falco..."
echo -e "*******************************************************************************************************************"


tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding falco repo"
echo -e "*******************************************************************************************************************"
tput setaf 2

curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list
sudo apt-get update -y





tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding Linux Headers - If you are not using Ubuntu, you will need to add the headers to your deployment manually"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo apt-get install -y falco
sudo systemctl start falco
sudo systemctl enable falco


tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Installing and enabling falco"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo apt-get -y install linux-headers-$(uname -r)

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Falco namespace"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl create ns falco

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding Falco Charts to Helm Repo"
echo -e "*******************************************************************************************************************"
tput setaf 2
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying Falco with EBPF enabled"
echo -e "*******************************************************************************************************************"
tput setaf 2
helm install falco falcosecurity/falco -f values-falco.yaml -f custom-nginx.yaml --namespace falco


tput setaf 3
echo -e "\n \n*******************************************************************************************************************"
echo -e "Falco deployment complete - Verify that the Falco pod has been created in the Falco namespace and that its running"
echo -e "*******************************************************************************************************************"
tput setaf 2

echo -e "\n\n"
