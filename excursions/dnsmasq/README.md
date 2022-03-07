### As of 3/6/2022 this is a WIP.
### Note: This is an add-on component for readers who do not want to use nip.io for name resolution.  


The scripts in the book are all designed to use nip.io for name resolution.  If you want to use dnsmasq instead, you will need to edit the scripts that create Ingress rules to use a domain name that you have configured in the dnsmasq.conf configuration.

# Local name resolution for Kubernetes development clusters

This is an add-on to the original book deployment that we use.  We have the need to present using a more complex deployment than a single KinD cluster, and while there are a number of other methods to spin up multiple clusters on a single machine, we really wanted to keep the cost of entry to work on multiple clusters to be as low as possible since many readers may not have access to systems with a hypervisor/etc...

Using DNSmasq will allow you to create multiple "local domains" that can be directed to Ingress controllers, Istio IngressGateways, etc... In our example, we are only configuring a single domain, foowidgets.com, that will direct all queries for the domain to the IP address of our KinD Ingress controller.  You can add as many domains as you would like for testing, the clusters do not need to be on the same host.

Using DNSmasq allows you to have a fully disconnected cluster running on a development system like a laptop without requiring an internet connection for name rsolution like nip.io.
  
# Requirements

You will need a Kubernetes cluster, of course, we are using a KinD cluster like we provision in the book.

To deploy the solution, you will need to add an IP addresses to your host.  You can add an IP any way that you are comfortable doing - you can add an additional NIC if you are using a VM, or you can just add a virtual IP addresses to your existing NIC.  For this example, we will add an IP address to our existing NIC running on Ubuntu 20.04.

Example IP use:

-  The host has a main IP of 10.2.1.40 - In our example, our KinD cluster is already deployed and bound to 10.2.1.40.
   (This does not need to be a KinD server, it can be any deployed Kubernetes cluster)
-  We need one more IP addresses added, so we will add 10.2.1.39 as a virtual IP to our NIC.  This IP will be used for our dnsmasq container.

# Adding additional IP's

Find the name of your adapter, it's probably ens160, but it could be different.  You can find your active adapter using ip addr, look for your IP address and make a note of the name of the interface.  In our example, we are going to add two addresses to our ens160 NIC, adding 10.2.1.38 and 10.2.1.39.
```
sudo ip addr add 10.2.1.39/24 broadcast 10.2.1.255 dev ens160 label ens160:1
```

Verify that the IP addresse was added by executing ip addr and look for the adapater name for your main NIC.  In our example, you will see that ens160 now has (2) IP addresses assigned, 10.2.1.39, and 10.2.1.40

2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:af:17:02 brd ff:ff:ff:ff:ff:ff
    inet 10.2.1.40/24 brd 10.2.1.255 scope global ens160
       valid_lft forever preferred_lft forever
    inet 10.2.1.39/24 brd 10.2.1.255 scope global secondary ens160:1
       valid_lft forever preferred_lft forever

# Scripts and their function

[dnsmasq.conf] - This configuration file is stored in the excursions/dnsmasq directory and will be mounted as a volume when you start the dnsmasq container.  You must edit the file to reflect your network configuration.  This requires changing the first edge DNS server, replacing 10.2.1.14 with your desired DNS server.  If you do not need any additional local name resolution, you can remove the example 10.2.1.40 and use only public internet servers like Cloudflare or Google.

# The dnsmasq.conf file

Our dnsmasq.conf configuration file is shown below.
```
# Enable Logging
log-queries

# dont use hosts nameservers
no-resolv

# This section defines where DNS queries will forward for any domain not defined in the next section
server=10.2.1.14
server=1.1.1.1

# Define the Wildcard domains you want below.  Each domain should point to a different IP for the defined domain.
# In this example, we have two KinD clusters, one for a domain called foowidgets.com which will send all traffic to 10.2.1.40 (the IP for the host running the KinD cluster)
address=/foowidgets.com/10.2.1.40
```

# Deploy your dnsmasq container

We are using an existing image that includes a GUI to view the queries to the dnsmasq container, which is exposed on port 8080, using a username and password of admin/admin.

Now that you have your dnsmasq.conf configuration file completed, you can start the dnsmasq container using a docker run from within the excursions/dnsmasq directory:

```
docker run --name dnsmasq -d -p 10.2.1.39:53:53/udp -p 10.2.1.39:53:53/tcp -p 10.2.1.39:8080:8080 -v $PWD/dnsmasq.conf:/etc/dnsmasq.conf --log-opt "max-size=100m" -e "HTTP_USER=admin" -e "HTTP_PASS=admin" --restart always jpillora/dnsmasq
```

To explain the Docker run command - We are naming the container dnsmasq, running it in the background, exposing ports on ONLY the newly added IP addresses (10.2.1.39), mounting the dnsmasq.conf file in the container, setting log options, and finally, setting the username and password for the GUI view.

# Set machines to use the dnsmasq server as your primary DNS server

This is designed to work for any machine on your network that you may want to use for testing workload running on your KinD cluster(s).  Simply assign your main IP from your hosts NIC as the DNS server.  In our example, we will use 10.2.1.40 as the DNS server.

# Verify that your dnsmasq container is working as expected

On a machine that you have configured to use dnsmasq, ping any name with your domain in the dnsmasq.conf file.  You will see that the name resolves to the IP address assigned in the configuration file.  For example, in our example, we pinged three unique hosts in the foowidgets.com domain:

ping www.foowidgets.com
PING www.foowidgets.com (10.2.1.39) 56(84) bytes of data.
64 bytes from 10.2.1.160 (10.2.1.39): icmp_seq=1 ttl=64 time=1.69 ms

ping kiali.foowidgets.com
PING kiali.foowidgets.com (10.2.1.39) 56(84) bytes of data.
64 bytes from 10.2.1.160 (10.2.1.39): icmp_seq=1 ttl=64 time=5.17 ms

ping oidc.foowidgets.com
PING oidc.foowidgets.com (10.2.1.39) 56(84) bytes of data.
64 bytes from 10.2.1.160 (10.2.1.39): icmp_seq=1 ttl=64 time=1.14 ms

Each name will be directed to the assigned service in the cluster by the Ingress controller.

# Using the GUI

On any machine on the network, you can access the dnsmasq GUI using the IP assigned in the Docker run command, in our example, 10.2.1.39 on port 8080.

