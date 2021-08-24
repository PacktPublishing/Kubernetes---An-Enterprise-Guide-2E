#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "To make this and future exercises easier, we will grant the currently logged on user, $USER, passwordless sudo"
echo -e "You will need to provide your password for the update, but after that, sudo commands will not require a password."
echo -e "*******************************************************************************************************************"
sudo echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/kubernetes-book-nopwd-root-for-$USER

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Docker Installation started..."
echo -e "*******************************************************************************************************************"

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Updating Repo and adding Docker repo apt-key"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo apt-get -y update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding Docker repo"
echo -e "*******************************************************************************************************************"
tput setaf 2
echo \
 "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Installing Docker"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Enabling and Starting Docker"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo systemctl enable docker
sudo systemctl start docker

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding current user to Docker group"
echo -e "*******************************************************************************************************************"
tput setaf 2
sudo usermod -aG docker $USER

exec su -p $USER

