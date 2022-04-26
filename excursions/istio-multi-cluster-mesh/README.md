# Istio Multi-Cluster Service Mesh with KinD and DNSMasq - WIP April 26, 2022  
This repo contains an extra Excursion from the original book material to provide experience creating a Multi-Cluster service mesh using a single Host running two different KinD Clusters.  
  
# Overview of Deployment  
To deploy the example clusters provided in this repo, we suggest the following:  
  
- A Host with at least TWO free IP Addresses.  These can be Virtua IP's (VIP's) or physical/virtual NIC's with unused IP Addrsses.  For this excursion we will assign two new VIP's on our Hosts single NIC.  
- This repository for the deployent scripts.  
- DNSmasq deployed using the deployment steps in the execursions/dnsmasq directory for Istio-Ingressgateway name resolution.  
  
# Example Network Configuration  
Our example network is on 10.2.1.0/24  
  
Host Main IP: 10.2.1.167/24  
Host main NIC: ens33
  
Additional VIP's added to ens33:  10.2.1.40/24 and 10.2.1.41/24  
  
## Adding VIP's to the Hosts NIC  
To add the two VIP's, we execute an ip addr add command for each VIP to be added:   
```  
sudo ip addr add 10.2.1.40/24 broadcast 10.2.1.255 dev ens33 label ens33:1  
sudo ip addr add 10.2.1.41/24 broadcast 10.2.1.255 dev ens33 label ens33:2  
```  
Once added you an look at the output from an ip addr command to verify the additional IP's were added.  
  
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000  
    link/ether 00:0c:29:80:9a:7f brd ff:ff:ff:ff:ff:ff  
    inet 10.2.1.167/24 brd 10.2.1.255 scope global dynamic ens33  
       valid_lft 3719sec preferred_lft 3719sec  
    inet 10.2.1.40/24 brd 10.2.1.255 scope global secondary ens33:1  
       valid_lft forever preferred_lft forever  
    inet 10.2.1.41/24 brd 10.2.1.255 scope global secondary ens33:2  
       valid_lft forever preferred_lft forever  
    inet6 fe80::20c:29ff:fe80:9a7f/64 scope link  
       valid_lft forever preferred_lft forever  
  
# Repository Scripts/File Overview  
This repo contains various ascript and configuration files to make creating the deployments as easy as possible.  So what are the functions of each file in the repo?  
  
## KinD Cluster Configuration Files  
There are two cluster configuration files for the KinD clusters we will need to create.  
  
- test-cluster01  
- test-cluster02  
  
Each cluster configuration will need to be updated to use the VIP's for your network.  For our example the cluster01 will use VIP 10.2.1.40 and cluster02 will use VIP 10.2.1.41  -  If you need to change these values, edit each cluster config and replace the (4) IP's in the file(s) with the values for your network before creating the clusters.  

# Deploying the KinD Clusters  
Now that the cluster configurations contain the VIP's for your network, create both clusters using the create-clusters.sh script in the repository.  This script will deploy both KinD clusters that we will use for the exercise.  
  
```
./create-clusters.sh  
```
