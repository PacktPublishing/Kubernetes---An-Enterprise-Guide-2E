#!/bin/bash
clear

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Adding Virtual IP addresses to the Hosts main NIC"
echo -e "*******************************************************************************************************************"
tput setaf 3

export nics = ip -o link show | awk '{print $2,$9}'
echo $nics(1)

tput setaf 5
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying DNSmasq Container using the dnsmasq.conf Configuration file"
echo -e "*******************************************************************************************************************"
tput setaf 3
