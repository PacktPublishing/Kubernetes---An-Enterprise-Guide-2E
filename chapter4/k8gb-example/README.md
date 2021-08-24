# K8GB Installation Scripts   
This directory contains scripts to create the two clusters used in Chapter 4's K8GB example.    
  
## Requirements for Cluster Creation  
  
To create the example from the book, you will need access to the following:  
  
- (2) New Servers running Ubuntu 20.04  
- The scripts in this repo  
- A DNS server with permissions to create a new Zone that will be delegated to the CoreDNS servers in the K8s clusters  
- The required K8GB DNS entries for the CoreDNS servers in each K8s clusters (For our example, we will use a Windows 2019 Server as the DNS server)  
- All scripts assume an internal subnet range of 10.2.1.0/24    -    You will need to edit the values for your network  
      
# Using the Scripts to create the Infrastructure    
The following list contains a high level overview of how the scripts can be used to create the K8GB deployment described in Chapter 4.  
  
## Infrastructure Overview:  
  
### Ubuntu Server - NYC Cluster  
- Ubuntu Server 20.04, IP Address: 10.2.1.157  
- Single node Kubernetes Cluster created the script in this repo, create-kubeadm-single.sh
- MetalLB installed in the Cluster, using the configuration and installaion files in the metallb directory, install-metallb-nyc.sh, this will reserve a few IP addresses for K8s LB services (10.2.1.220-10.2.1.222)  
- K8GB Installed using the script in the repo in the k8gb directory, deploy-k8gb-nyc.sh  

### Ubuntu Server - Buffalo Cluster  
- Ubuntu Server 20.04, IP Address: 10.2.1.119  
- Single node Kubernetes Cluster created the script in this repo, create-kubeadm-single.sh  
- MetalLB installed in the Cluster, using the configuration and installaion files in the metallb directory, install-metallb-buf.sh, this will reserve a few IP addresses for K8s LB services (10.2.1.223-10.2.1.225)  
- K8GB Installed using the script in the repo in the k8gb directory, deploy-k8gb-nyc.sh  
  
### Windows 2019 Server  
- Windows Server running 2019 Server, IP address: 10.2.1.14  
- New Conditional Forwarder for the gb.foowidgets.k8s zone, forwarding to both CoreDNS servers in each K8s cluster, if you are using the same subnet as the example, you would forward to: 10.2.1.220 and 10.2.1.223  
- One DNS record for each exposed CoreDNS pod in the clusters -  If using the same subnet as the example, the entries would be:  
  
  gslb-ns-nyc-gb     10.2.1.220  
  gslb-ns-buf-gb     10.2.1.223  
  
### Kubernetes Example Application  
- A simple NGINX server will be deployed to each cluster, you can deploy the application using the manifest in the k8gb directory called nginx-fe-deploy.yaml  
- A Gslb object in each cluster for the NGINX deployment created using the scripts for each cluster in the k8gb directory, k8gb-example-nyc.yaml and k8gb-example-buf.yaml  

  You can just use kubectl to deploy the appropriate Gslb to each cluster:  kubectl create k8gb-example-nyc.yaml -n k8gb  for the NYC cluster and k8gb-example-buf.yaml for the Buffalo cluster  
  
  This will create a Gslb reecord in each cluster using the Ingress name fe.gb.foowidgets.k8s, using the NYC cluster as the primary cluster.  
  
# Testing K8GB  

  


  
