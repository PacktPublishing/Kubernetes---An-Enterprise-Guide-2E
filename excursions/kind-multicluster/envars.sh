# This file contains the information required to automate the deployment of a multi-cluster environment using KinD
# You can accomplish this with various different tools, but we will use simple Bash exports to make it easier for all readers to follow

# Set the main NIC name and three IP information (ie: ens33 with IP addresses 10.2.1.67, 10.2.1.40, and 10.2.1.41)

export main_nic="ens33"
export nic_ip1="10.2.1.67"
export nic_ip2="10.2.1.40"
export nic_ip3="10.2.1.41"
export nic_gw="10.2.1.1"
export nic_edge_dns="10.2.1.1"  # The first IP address (nic_ip1) will be used as the primary DNS server for the host, this is a backup DNS entry)

# Set the names for the KinD Clusters (ie: cluster1 and cluster2)

export cluster1_name="cluster1"
export cluster2_name="cluster2"

# Set the Domains that will be used for DNSmasq

export dns_domain1="cluster1.local"
export dns_domain2="cluster2.local"

