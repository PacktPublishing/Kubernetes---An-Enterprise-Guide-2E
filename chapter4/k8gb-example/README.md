# K8GB Installation Scripts - (BETA Release) - Last Updated: 1/19/2022  
This is a WIP (Work in Progress) - When the scripts are complete, we will remove the WIP status.  
This directory contains scripts to create the two clusters used in Chapter 4's K8GB example.    
  
Once complete, the scripts in this repo will move to the K8GB main GIT repo as an example use-case, the main GIT for for the K8GB project is located at https://github.com/k8gb-io/k8gb  
  
## Requirements for Cluster Creation  
  
To create the example from the book, you will need access to the following:  
  
- (2) New Servers running Ubuntu 20.04 or 18.04  
- The scripts in this repo  
- A DNS server with permissions to create a new Zone that will be delegated to the CoreDNS servers in the K8s clusters  
- The required K8GB DNS entries for the CoreDNS servers in each K8s clusters (For our example, we will use a Windows 2019 Server as the DNS server)  
- All scripts assume an internal subnet range of 10.2.1.0/24    -    You will need to edit the values for your network 
- The main Edge DNS server you are using for this implementation should be the default DNS server for your clients.   
      
# Using the Scripts to create the Infrastructure    
The following list contains a high level overview of how the scripts can be used to create the K8GB deployment described in Chapter 4.  
  
# Infrastructure Overview:  
## Design Overview
The demo assumes that you have your own DNS server that you can create a delegated zone in.  Our example will use a Windows Server, but any DNS server will work.  You will need to change the IP's to match your subnet - Our labe uses 10.2.1.0/24  
  
                    Kubeadm Cluster 1 (NYC)  10.2.1.157  
                   /  (MetalLB Config: 10.2.1.220-10.2.1.222)  
    --------------    (CoreDNS LB IP: 10.2.1.220)  
    - DNS Server -    
    - 10.2.1.14  -    [Example K8GB NGINX URL: fe.gb.foowidgets.k8s]  
    --------------  
                   \  
                    Kubeadm Cluster 2 (BUF)  10.2.1.119  
                      (MetalLB Config: 10.2.1.223-10.2.1.225) 
                      (CoreDNS LB IP: 10.2.1.223)  
    
### Ubuntu Server - NYC Cluster Build  
- Ubuntu Server 20.04, IP Address: 10.2.1.157  ** Your IP will be different, make a note of it for the steps **
- Single node Kubernetes Cluster created the script in this repo, create-kubeadm-single.sh
- MetalLB installed in the Cluster, using the configuration and installaion files in the metallb directory, create-metallb-nyc.sh - Before executing, edit the metallb-config-nyc.yaml, the default config will reserve a few IP addresses for K8s LB services (10.2.1.220-10.2.1.222)  ** Change this to a range that exists on your network **
- K8GB and demo app installed using the script in the repo from the k8gb directory, deploy-k8gb-nyc.sh  ** Edit the k8gb-nyc-values.yaml to reflect any values for your network, at a minimum, you will need to change the edgeDNSServer: "10.2.1.14" value to point to your internal DNS server **  
  
You will need the IP address that was assigned by MetalLB for the K8GB's LoadBalancer IP.  In our example, the IP assigned was 10.2.1.220.  

### Ubuntu Server - Buffalo Cluster Build  
- Ubuntu Server 20.04, IP Address: 10.2.1.119  ** Your IP will be different, make a note of it for the steps **
- Single node Kubernetes Cluster created the script in this repo, create-kubeadm-single.sh  
- MetalLB installed in the Cluster, using the configuration and installaion files in the metallb directory, create-metallb-buf.sh - - Before executing, edit the metallb-config-nyc.yaml, the default config will reserve a few IP addresses for K8s LB services (10.2.1.223-10.2.1.225)  ** Change this to a range that exists on your network **
- K8GB and demo app installed using the script in the repo from the k8gb directory, deploy-k8gb-buf.sh  ** Edit the k8gb-buf-values.yaml to reflect any values for your network, at a minimum, you will need to change the edgeDNSServer: "10.2.1.14" value to point to your internal DNS server **  
  
You will need the IP address that was assigned by MetalLB for the K8GB's LoadBalancer IP.  In our example, the IP assigned was 10.2.1.223.  
  
### Windows 2016/2019/2022 Server (Or any Internal DNS Server)    
- Windows Server, IP address: 10.2.1.14  
- One DNS record for each exposed CoreDNS pod in the clusters, these entries must be in your base root domain, for our example, foowidgets.k8s - If using the same subnet as the example, the entries would be:  
  
  gslb-ns-nyc-gb     10.2.1.220  
  gslb-ns-buf-gb     10.2.1.223  

- Create a new delegation for the gb.foowidgets.k8s zone, forwarding to both CoreDNS servers (1) in each K8s cluster - the delegated FQDNs for our CoreDNS servers in our example are: gslb-ns-us-nyc-gb.foowidgets.k8s and gslb-ns-us-buf-gb.foowidgets.k8s.  If you are using a Windows DNS server, you can right click your domain in DNS Manager and select 'New Delegation'.  It will ask you for the domain you want to delegate, enter gb and click next.  The final step is to add the delegated Name Servers - add both name servers, gslb-ns-us-nyc-gb.foowidgets.k8s and gslb-ns-us-buf-gb.foowidgets.k8s. and click next to finish the delegation.  
    
### Kubernetes Example Application  
  
The K8GB script exeecuted for each cluster will create the following:  
  
- A new k8gb namespace 
- A new demo namespace  
- k8gb will be deployed using Helm in the k8gb namespace 
- A new gslb object will be created for the demo application  
- A NGINX web server will be deployed into the demo namespace  
  
  
# Testing K8GB  
## Testing the initial deployment which defaults to NYC as the primary cluster  
Now that K8GB has been deployed to both clusters and an example web server has been deployed, we can test K8GB.  
  
Open a browser on your network and enter the name that was assigned in the gslb object, fe.gb.foowidgets.k8s  
  
![image](https://user-images.githubusercontent.com/60396639/150191283-18354262-9572-4d44-8dc6-25cfe11c3e77.png)
  
Since the primary GeoTag was set to us-nyc, this should reply with the HTML page from the NYC NGINX server.  
  
## Testing failover to the Buffalo cluster  
To make the request fail over to the Buffalo cluster, we will simulate a failure in NYC by scaling the NGINX deployment to 0 replicas.  In the NYC cluster, run the following command:  
  
```
kubectl scale deployment nginx-fe -n demo --replicas=0  
```  
   
This will cause K8GB to fail the record from the NYC cluster to the Buffalo cluster.  This usually happens within 1-5 seconds.  
  
Either refresh your browser window, or open a new tab/instance and enter the URL to test the NGINX server, fe.gb.foowidgets.k8s 
  
![image](https://user-images.githubusercontent.com/60396639/150191509-88daa179-b667-42d7-8b0a-d9225c300c8e.png)
  
Now that the NYC site has a failed deployment, the reply from the NGINX server should be from the Buffalo instance.  
  
# Success!
This concludes the demo for K8GB.  
  
  
We would like to thank the K8GB team for their awesome project!  With a special thank you to Yury Tsarev!
