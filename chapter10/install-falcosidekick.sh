#!/bin/bash
clear

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying Falco Sidekick-UI and Sidekick with Kubeless Enabled"
echo -e "*******************************************************************************************************************"
tput setaf 2
helm install falcosidekick falcosecurity/falcosidekick -f values-sidekick.yaml --namespace falco

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Ingress rule for the Sidekick-UI"
echo -e "*******************************************************************************************************************"
tput setaf 2
sleep 2
export hostip=$(hostname  -I | cut -f1 -d' ')
envsubst < falco-ui-ingress.yaml | kubectl create -f - --namespace falco

tput setaf 6
echo -e "\n\nThe Sidekick-UI has been added to ingress, you can open the UI using http://sidekick-ui.$hostip.nip.io/ui"

echo -e "\n\n"
