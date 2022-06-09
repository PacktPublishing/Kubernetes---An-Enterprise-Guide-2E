# KinD Multi-Cluster Deployment using DNSmasq   
This repo contains an extra Excursion from the original book material to provide experience creating a Multi-Cluster Kubernetes development environment using a single Host running two different KinD Clusters.  
  
While our example deploys (2) clusters, you can add as many as you want.  You are only limited by the resources available on your development server.  
 
The script were updated on 6/9 to make deployment easier.  All unique options to the deployment are in the envars.sh scipt and the deployment scripts will use the information in this file to create both clusters and a DNSmasq container with a single script execution.   You will need to edit the envars.sh file before deploying the clusters.
 
# Overview of Deployment  
To deploy the example clusters provided in this repo, we suggest the following:  
  
- A Host with at least three static IP addresses, the main NIC IP and (2) Additional IP's on the network. 
- This repository for the deployment scripts.  
- DNSmasq for local name resolution for any Ingress testing you may need to do.    
  
# Example Network Configuration  
Our example network is on 10.2.1.0/24  
  
Host Main IP: 10.2.1.67/24  
Host main NIC: ens33
  
Additional IP's added to ens33:  10.2.1.40/24 and 10.2.1.41/24  - we will also statically assign the main IP address in our example since it was assigned via DHCP.  
    
# Repository Scripts/File Overview  
This repo contains various scripts and configuration files to make creating the deployments as easy as possible.  So, what are the functions of each file in the repo?  

## Directory Structure and Files  
  
| File                     | Description                              |  
| ------------------------ | ---------------------------------------- |  
| calico.yaml              | Deploys Calico to the KinD Cluster       |  
| cluster1.yaml            | Config file used for cluster1	      |    
| cluster2.yaml            | Config file used for cluster2            |  
| create-clusters.sh       | Creates DNSmasq Container and Clusters   |     
| create-kind-cluster.sh * | Creates the clusters                     |  
| dnsmasq.conf             | Config file used for DNSmasq             |
| envars.sh                | Main File for unique cluster Config      |  
| get_helm.sh *            | Download and installs Helm3              | 
| install-kind.sh *        | Download and installs KinD               | 
| inginx-deploy.yaml *     | Deploys NGINX-Ingress to cluster         |   
| README.md	           | This File                                |  
| * = Script is called from another script                            |
      
## Editing the envars.sh Configuration File  
This file contains every value you need to create two KinD clusters with DNSmasq fully configured using a single deployment script called create-clusters.sh.  
We had to make a lot of assumptions to automate the deployment, so we assume the following:

- A default Ubuntu 20.04 Server  
- A subnet value of /24  
- Whatever IP is assigned to the main NIC will be re-used as the main NIC IP (even if its DHCP assigned to begin with)  
  
If you are using DHCP for the main NIC, make a note of the assigned IP since you will reuse it in the envars.sh file.  You will also need to reserve the address in your DHCP server to avoid any conflicts in the future. If you try to use a different IP, other than the currently assigned IP on the host, you will be dsconnected during the sript execution and the scripts will halt.  (Sorry, working on a different solution to avoid this).  

Simple edit the values to your requirements:  
  
```
# This file contains the information required to automate the deployment of a multi-cluster environment using KinD
# You can accomplish this with various different tools, but we will use simple Bash exports to make it easier for all readers to follow

# Set the main NIC name and three IP information (ie: ens33 with IP addresses 10.2.1.67, 10.2.1.40, and 10.2.1.41)

export main_nic="ens33"
export nic_ip1="10.2.1.67"
export nic_ip2="10.2.1.40"
export nic_ip3="10.2.1.41"
export nic_gw="10.2.1.1"
export nic_edge_dns="10.2.1.1"  # The first IP address (nic_ip1) will be used as the primary DNS server for the host, this is a backup DNS entry)

# Set the Domains that will be used for DNSmasq

export dns_domain1="cluster1.local"
export dns_domain2="cluster2.local"
```

| Value            | Descrition                                                        |  
| ---------------- | ----------------------------------------------------------------- |  
| main_nic         | This is the name of your NIC in Ubuntu                            |  
| nic_ip1          | This is the main IP address that will be used, as described above |  
| nic_ip2          | This will be used to create the first cluster                     |  
| nic_ip3          | This will be used to create the second cluster                    |  
| nic_gw           | This is your default gateway                                      |  
| nic_edge_dns     | This is your DNS server for standard queries (often your GW)      |  
| dns_domain1      | This is the domain name you want to use for the first cluster     |  
| dns_domain2      | This is the domain name you want to use for the second cluster    |  
  
Edit the values and save the file before continuing to deploy the clusters.  
  
Even though we will send a restart to netplan, you will remain connected to the host since the main IP will not change.    
  
# Deploying the KinD Clusters and DNSmasq (Script: create-clusters.sh)     
You can now execute the create-custers.sh script which will create every object required including the KinD clusters, the DNSmasq container, resolv.conf updates, and reconfigure your NIC with the additional addresses.  
  
Once the script completes, you can verify the deployment by listing the KinD clusters.  
  
```
kind get clusters
```
cluster1  
cluster2  
  
You can also look at the Docker contaners by executing a docker ps command.  
  
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                                                                    NAMES  
234c01037812   kindest/node:v1.21.1   "/usr/local/bin/entr…"   3 minutes ago    Up 2 minutes    10.2.1.41:6443->6443/tcp                                                 cluster2-control-plane  
1f969f618684   kindest/node:v1.21.1   "/usr/local/bin/entr…"   3 minutes ago    Up 2 minutes    10.2.1.41:80->80/tcp, 10.2.1.41:443->443/tcp, 10.2.1.41:2222->2222/tcp   cluster2-worker  
c72c3b382bec   kindest/node:v1.21.1   "/usr/local/bin/entr…"   4 minutes ago    Up 3 minutes    10.2.1.40:6443->6443/tcp                                                 cluster1-control-plane  
36778679159e   kindest/node:v1.21.1   "/usr/local/bin/entr…"   4 minutes ago    Up 3 minutes    10.2.1.40:80->80/tcp, 10.2.1.40:443->443/tcp, 10.2.1.40:2222->2222/tcp   cluster1-worker  
5e91473fda3e   jpillora/dnsmasq       "webproc --config /e…"   30 minutes ago   Up 30 minutes   10.2.1.67:53->53/tcp, 10.2.1.67:8080->8080/tcp, 10.2.1.67:53->53/udp     dnsmasq  
  
You can see that the DNSmasq container is listening on the main NIC, cluster1 is listening on the 10.2.1.40 IP and cluster2 is listening on the 10.2.1.41 IP.   
# Kubernetes Context    
Once you have deployed the clusters, you will have two clusters in your Kubernetes config context:  
  
```
kubectl config get-contexts
```  

CURRENT   NAME            CLUSTER         AUTHINFO        NAMESPACE  
          kind-cluster1   kind-cluster1   kind-cluster1  
          kind-cluster2   kind-cluster2   kind-cluster2  
  
Switch your context as needed when you are deploying workloads to a cluster.    

## Configuring other Clients to use DNSmasq  
The script will configure the local machine to use the DNSmasq container as the main DNS server. Any client on your local network can use DNSmasq for testing by editing the DNS servers and pointing the primary server to your DNSmasq IP address (Your 1st IP addresses on the Ubuntu host).  

## Testing DNSmasq and NGINX Ingress  

Once configured, you can test the container by pinging any name in each DNSmasq domain. Since each DNSmasq domain is set up as a wildcard domain, we can use any host name to test name resolution:   
  
PING www.cluster1.local (10.2.1.40) 56(84) bytes of data.    
64 bytes from 10.2.1.40 (10.2.1.40): icmp_seq=1 ttl=64 time=0.032 ms    
64 bytes from 10.2.1.40 (10.2.1.40): icmp_seq=2 ttl=64 time=0.061 ms    
  
PING www.cluster2.local (10.2.1.41) 56(84) bytes of data.  
64 bytes from 10.2.1.41 (10.2.1.41): icmp_seq=1 ttl=64 time=0.030 ms  
64 bytes from 10.2.1.41 (10.2.1.41): icmp_seq=2 ttl=64 time=0.033 ms  

This confirms that DNSmasq is working and the domains are resolving to their correct Ingress-Gateway IP addresses.  
  
# What can you do now?  
While a single KinD cluster can be used to learn a lot, having multiple clusters available allows you to extend your development use-cases to include tools that can leverage multiple clusters like:  
  
- Multi-Cluster Istio (A WIP excursion that will be released soon)  
- Federated authentication testing with and IdP like Openunison from Tremolo Security  
- K8GB (A WIP excursion that will be published in Q3)  
- And many more....  
  
Using KinD for these tests will allow you to learn and implement use-cases that many Enterprises require, all while limiting the require resources for the testing.  
  
  
