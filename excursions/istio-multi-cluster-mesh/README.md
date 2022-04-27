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
  
DNSmasq will be configured with two domains, one for each cluster.  The assigned domain names and VIP's can be edited in the dnsmasq.conf file.  

The portion you will need to update are shown below:  
```
# This section defines where DNS queries will forward for any domain not defined in the next section
server=10.2.1.14
server=1.1.1.1

# Define the Wildcard domains you want below.  Each domain should point to a different IP for the defined domain.
# In this example, we have two KinD clusters, one for a domain called foowidgets.com which will send all traffic to 10.2.1.39 (the worker node for this KinD cluster.
address=/istio-cls1.com/10.2.1.40
address=/istio-cls2.com/10.2.1.41
```
The first section should contain any edgde DNS servers you will forward to from your DNSmasq container.  The second portion defines the domains that we will use  and the IP address of the Istio-Ingressgateway IP.  In our configuration, we will forward *.istio-cls1.com to 10.2.1.40 and *.istio-cls2.com to 10.2.1.41.  
  
## Adding VIP's to the Hosts NIC  
To add the two VIP's for our KinD Clusters and the IP we will use for the DNSmasq container, we execute an ip addr add command for each VIP to be added:   
```  
sudo ip addr add 10.2.1.39/24 broadcast 10.2.1.255 dev ens33 label ens33:1
sudo ip addr add 10.2.1.40/24 broadcast 10.2.1.255 dev ens33 label ens33:2  
sudo ip addr add 10.2.1.41/24 broadcast 10.2.1.255 dev ens33 label ens33:3  
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

# Deploying the KinD Clusters and DNSmasq   
Now that the cluster configurations contain the VIP's for your network, create both clusters using the create-clusters.sh script in the repository.  This script will deploy both KinD clusters that we will use for the exercise.  You will need to edit the Docker command that deploys the DNSmasq container to reflect the IP address you have added for DNSmasq.  In our example, we will use the 10.2.1.39 VIP.  Edit the docker run line with the IP address you will use for DNSmasq and save the file.  
  
docker run --name dnsmasq -d -p 10.2.1.39:53:53/udp -p 10.2.1.39:53:53/tcp -p 10.2.1.39:8080:8080 -v $PWD/dnsmasq.conf:/etc/dnsmasq.conf --log-opt "max-size=100m" -e "HTTP_USER=admin" -e "HTTP_PASS=admin" --restart always jpillora/dnsmasq  
  
```
./create-clusters.sh  
```
The cluster deployents are, essentially, the same as the standard book exercises.  Once deployed, you will have two clusters running, one on each VIP you have assigned.  
  
Executing a docker ps will show show 4 containers running:  
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                                                    NAMES
7850ab3bb562   jpillora/dnsmasq       "webproc --config /e…"   7 minutes ago    Up 7 minutes    10.2.1.39:53->53/tcp, 10.2.1.39:8080->8080/tcp, 10.2.1.39:53->53/udp     dnsmasq  
b9f112d571e4   kindest/node:v1.18.2   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes   10.2.1.41:80->80/tcp, 10.2.1.41:443->443/tcp, 10.2.1.41:2222->2222/tcp   test-cluster02-worker  
58f984afe306   kindest/node:v1.18.2   "/usr/local/bin/entr…"   4 minutes ago   Up 4 minutes   10.2.1.41:6443->6443/tcp                                                 test-cluster02-control-plane  
6ff2842092b6   kindest/node:v1.18.2   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes   10.2.1.40:80->80/tcp, 10.2.1.40:443->443/tcp, 10.2.1.40:2222->2222/tcp   test-cluster01-worker  
61044ca25c64   kindest/node:v1.18.2   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes   10.2.1.40:6443->6443/tcp                                                 test-cluster01-control-plane  
    
# Configure a Host to use DNSmasq as DNS Server  
Any machine that you will use to test the multi-cluster mesh design will need to use the IP address of your DNSmasq deployment as its DNS server.  In our example we have bound the IP 10.2.1.39 to DNSmasq - So we have configured our main Host to use 10.2.1.39 as its DNS server.  Once configured, you can test the container by pinging any name in each DNSmasq domain.  
  
PING www.istio-cls1.com (10.2.1.40) 56(84) bytes of data.  
64 bytes from 10.2.1.40 (10.2.1.40): icmp_seq=1 ttl=64 time=0.032 ms  
64 bytes from 10.2.1.40 (10.2.1.40): icmp_seq=2 ttl=64 time=0.061 ms  
  
PING www.istio-cls2.com (10.2.1.41) 56(84) bytes of data.  
64 bytes from 10.2.1.41 (10.2.1.41): icmp_seq=1 ttl=64 time=0.030 ms  
64 bytes from 10.2.1.41 (10.2.1.41): icmp_seq=2 ttl=64 time=0.033 ms  

This confirms that DNSmasq is working and the domains are resolving to their correct Ingress-Gateway IP addresses.  
  
  
