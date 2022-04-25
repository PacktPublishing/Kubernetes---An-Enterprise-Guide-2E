# Istio Multi-Cluster Service Mesh with KinD and DNSMasq - WIP April 25, 2022  
This repo contains an extra Excursion from the original book material to provide experience creating a Multi-Cluster service mesh using a single Host running two different KinD Clusters.  
  
# Overview of Deployment  
To deploy the example clusters provided in this repo, we suggest the following:  
  
- A Host with at least TWO free IP Addresses.  These can be Virtua IP's (VIP's) or physical/virtual NIC's with unused IP Addrsses.  For this excursion we will assign two new VIP's on our Hosts single NIC.  
- This repository for the deployent scripts.  
- DNSmasq deployed using the deployment steps in the execursions/dnsmasq directory for Istio-Ingressgateway name resolution.  
  
# Repository Scripts/File Overview  
This repo contains various ascript and configuration files to make creating the deployments as easy as possible.  So what are the functions of each file in the repo?  
  
## KinD Cluster Configuration Files  
There are two cluster configuration files for the KinD clusters we will need to create.  
  
- test-cluster01  
- test-cluster02  
- 
