# KinD Multi-Cluster Deployment using DNSmasq   
This repo contains an extra Excursion from the original book material to provide experience creating a Multi-Cluster Kubernetes development environment using a single Host running two different KinD Clusters.  
  
While our example deploys (2) clusters, you can add as many as you want.  You are only limited by the resources available on your development server.  
  
# Overview of Deployment  
To deploy the example clusters provided in this repo, we suggest the following:  
  
- A Host with at least three IP address, the main NIC IP and (2) Additional IP's on the network. 
- This repository for the deployent scripts.  
- DNSmasq for local name resolution for any Ingress testing you may need to do.    
  
# Example Network Configuration  
Our example network is on 10.2.1.0/24  
  
Host Main IP: 10.2.1.67/24  
Host main NIC: ens33
  
Additional IP's added to ens33:  10.2.1.40/24 and 10.2.1.41/24  
  
DNSmasq will be configured with two domains, one for each cluster.  The assigned domain names and IP's can be edited in the dnsmasq.conf file.  

The portion in the config you will need to update are shown below:  
```
# This section defines where DNS queries will forward for any domain not defined in the next section
server=10.2.1.14
server=10.2.1.1

# Define the Wildcard domains you want below.  Each domain should point to a different IP for the defined domain.
# In this example, we have two KinD clusters, one for a domain called foowidgets.com which will send all traffic to 10.2.1.39 (the worker node for this KinD cluster.
address=/cluster1.local/10.2.1.40
address=/cluster2.local/10.2.1.41
```  

The first section should contain any edgde DNS servers you will forward to from your DNSmasq container.  The second portion defines the domains that we will use  and the IP address of the Istio-Ingressgateway IP.  In our configuration, we will forward *.cluster1.local to 10.2.1.40 and *.cluster2.local to 10.2.1.41.  
## Adding IP's to the Hosts NIC  
To add additional IPs to your NIC, you need to edit the netplan config from our default Ubuntu 20.04 server.  This file is located here: /etc/netplan/00-installer-config.yaml  
  
Replace the contents of the file with the text below, changing the three IP's for your desired network configuration.  

```
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses: [10.2.1.67/24,10.2.1.40/24,10.2.1.41/24]
      gateway4: 10.2.1.1
      nameservers:
        addresses: [10.2.1.67, 10.2.1.1]
  version: 2
``` 
  
Save the file and to implement the new IP's, execute a netplan change:  
```
sudo netplan change
```
  
If you changed the main IP in the config file, you will be kicked off the host after executing the apply command.  Simply SSH into your host using the first IP you assigned in the configuration.  

  
# Repository Scripts/File Overview  
This repo contains various ascript and configuration files to make creating the deployments as easy as possible.  So what are the functions of each file in the repo?  

## Directory Structure and Files  
  
Script				Function  				Requires Editing
----------------------		-------------------------------------	----------------
calico.yaml			Deploys Calico to the KinD Cluster 	No  
cluster1.yaml			Config file used for cluster1		Yes - IP address changes  
cluster2.yaml			Config file used for cluster		Yes - IP address changes  
create-clusters.sh		Creates DNSmasq Container and Clusters	Yes - IP address change for DNSmasq Docker run command  
create-kind-cluster.sh		Creates the clusters			No - Called from create-clusters.sh  
dnsmasq.conf			Config file used for DNSmasq		Yes - IP address changes  
get_helm.sh  			Download and installs Helm3		No  
install-kind.sh			Download and installs KinD		No  
nginx-deploy.yaml		Deploys NGINX-Ingress to cluster	No  
README.md			-- This File --  
    
## KinD Cluster Configuration Files  
There are two cluster configuration files for the KinD clusters we will need to create.  
  
- cluster1  
- cluster2  
  
Each cluster configuration will need to be updated to use the IP's for your network.  For our example the cluster1 will use IP 10.2.1.40 and cluster2 will use IP 10.2.1.41  -  If you need to change these values, edit each cluster config and replace the (4) IP's in the file(s) with the values for your network before creating the clusters.  

# Deploying the KinD Clusters and DNSmasq (Script: create-clusters.sh)     
Now that the cluster configurations contain the VIP's for your network, create both clusters using the create-clusters.sh script in the repository.  This script will deploy both KinD clusters that we will use for the exercise.  You will need to edit the Docker command in the create-cluster.sh script that deploys the DNSmasq container to reflect the IP address you have added for DNSmasq.  In our example, we will use the 10.2.1.67 IP.  Edit the docker run line with the IP address you will use for DNSmasq and save the file.  

```  
docker run --name dnsmasq -d -p 10.2.1.39:53:53/udp -p 10.2.1.39:53:53/tcp -p 10.2.1.39:8080:8080 -v $PWD/dnsmasq.conf:/etc/dnsmasq.conf --log-opt "max-size=100m" -e "HTTP_USER=admin" -e "HTTP_PASS=admin" --restart always jpillora/dnsmasq  
```

Once you have edited the docker run command, execute the script to create the clusters and the DNSmasq container.  

```
./create-clusters.sh  
```
The cluster deployents are, essentially, the same as the standard book exercises.  Once deployed, you will have two clusters running, one on each VIP you have assigned.  
  
You can verify the clusters were created by executing a kind get clusters, you will see the output below:

```
kind get clusters
```
cluster1
cluster2  
  
Executing a docker ps will show show 5 containers running (4 containers for the KinD Clusters, and 1 container for DNSmasq) and their listening ports:
  
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                                                                    NAMES
234c01037812   kindest/node:v1.21.1   "/usr/local/bin/entr…"   3 minutes ago    Up 2 minutes    10.2.1.41:6443->6443/tcp                                                 cluster2-control-plane
1f969f618684   kindest/node:v1.21.1   "/usr/local/bin/entr…"   3 minutes ago    Up 2 minutes    10.2.1.41:80->80/tcp, 10.2.1.41:443->443/tcp, 10.2.1.41:2222->2222/tcp   cluster2-worker
c72c3b382bec   kindest/node:v1.21.1   "/usr/local/bin/entr…"   4 minutes ago    Up 3 minutes    10.2.1.40:6443->6443/tcp                                                 cluster1-control-plane
36778679159e   kindest/node:v1.21.1   "/usr/local/bin/entr…"   4 minutes ago    Up 3 minutes    10.2.1.40:80->80/tcp, 10.2.1.40:443->443/tcp, 10.2.1.40:2222->2222/tcp   cluster1-worker
5e91473fda3e   jpillora/dnsmasq       "webproc --config /e…"   30 minutes ago   Up 30 minutes   10.2.1.67:53->53/tcp, 10.2.1.67:8080->8080/tcp, 10.2.1.67:53->53/udp     dnsmasq
  
You can see that the DNSmasq container is listening on the main NIC, cluster1 is listening on the 10.2.1.40 IP and cluster2 is listening on the 10.2.1.41 IP.   
# Kubernetes Context  
Once you have deployed the clusters, you will have two clusters in your Kubernetes config context:  
  
``kubectl config get-contexts``  

CURRENT   NAME            CLUSTER         AUTHINFO        NAMESPACE
          kind-cluster1   kind-cluster1   kind-cluster1
*         kind-cluster2   kind-cluster2   kind-cluster2
  
Switch your context as needed when you are deploying workloads to a cluster.    

# Configure a Host to use DNSmasq as DNS Server  
Any machine that you will use to test the multi-cluster mesh design will need to use the IP address of your DNSmasq deployment as its DNS server.  In our example we have bound the IP 10.2.1.67 to DNSmasq - So we have configured our main Host to use 10.2.1.67 as its DNS server.  
  
Since /etc/resolv.conf is a managed file on a base Ubuntu 20.04, we will need to delete the original file (removing the symlink) and create a simple, two line, resolve.conf to replace it.  
  
```
sudo rm /etc/resolve.conf  
```
  
Then create a replacement file similar to the one below:  
  
```
sudo vi /etc/resolve.conf  
```  
nameserver 10.2.1.67  
nameserver 10.2.1.1  
  
The first entry needs to be the IP where DNSmasq is running, in our example, 10.2.1.67.  The second nameserver is a backup, our router in this example, which will only be used if the DNSmasq container is not running.  (If the second nameserver is used, you will not be able to resolve the cluster1 or cluster2 domain names)  
  
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
  
  
