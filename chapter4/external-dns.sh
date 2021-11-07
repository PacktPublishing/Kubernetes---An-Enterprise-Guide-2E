#!/bin/bash
clear

tput setaf 5
echo -e "\n*********************************************************************                                                                              **********************************************"
echo -e "Installing ExternalDNS"
echo -e "***********************************************************************                                                                              ********************************************"
tput setaf 2

tput setaf 5
echo -e "\n*********************************************************************                                                                              **********************************************"
echo -e "Looking up the service IP for ETCD"
echo -e "***********************************************************************                                                                              ********************************************"
tput setaf 2
ETCD_URL=$(kubectl -n kube-system get svc etcd-cluster-client -o go-template='{{                                                                               .spec.clusterIP }}')

tput setaf 5
echo -e "\n*********************************************************************                                                                              **********************************************"
echo -e "Injecting ETCD service IP into a temp manifest and creating final Exter                                                                              nalDNS manifest"
echo -e "***********************************************************************                                                                              ********************************************"
tput setaf 2
cat external-dns.yaml | sed -E "s/<ETCD_URL>/${ETCD_URL}/" > external-dns-deploy                                                                              ment.yaml

tput setaf 5
echo -e "\n*********************************************************************                                                                              **********************************************"
echo -e "Deploying ExternalDNS to the cluster"
echo -e "***********************************************************************                                                                              ********************************************"
tput setaf 2
kubectl apply -f external-dns-deployment.yaml

tput setaf 5
echo -e "\n\n*******************************************************************                                                                              ************************************************"
echo -e "ExternalDNS has been deployed to the cluster"
echo -e "***********************************************************************                                                                              ********************************************\n\n"
tput setaf 2

surovich@review-vm:~/Kubernetes---An-Enterprise-Guide-2E/chapter4$ cat external-dns.sh
#!/bin/bash
clear

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Installing ExternalDNS"
echo -e "*******************************************************************************************************************"
tput setaf 2

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Looking up the service IP for ETCD"
echo -e "*******************************************************************************************************************"
tput setaf 2
ETCD_URL=$(kubectl -n kube-system get svc etcd-cluster-client -o go-template='{{ .spec.clusterIP }}')

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Injecting ETCD service IP into a temp manifest and creating final ExternalDNS manifest"
echo -e "*******************************************************************************************************************"
tput setaf 2
cat external-dns.yaml | sed -E "s/<ETCD_URL>/${ETCD_URL}/" > external-dns-deployment.yaml

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Deploying ExternalDNS to the cluster"
echo -e "*******************************************************************************************************************"
tput setaf 2
kubectl apply -f external-dns-deployment.yaml

tput setaf 5
echo -e "\n\n*******************************************************************************************************************"
echo -e "ExternalDNS has been deployed to the cluster"
echo -e "*******************************************************************************************************************\n\n"
tput setaf 2

