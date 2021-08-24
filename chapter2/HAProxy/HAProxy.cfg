#!/bin/bash
clear
tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Collecting the IP addresses for the worker nodes"
echo -e "*******************************************************************************************************************"
tput setaf 2

worker1=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@" cluster01-worker)
worker2=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@" cluster01-worker2)
worker3=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@" cluster01-worker3)

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Creating the HAProxy directory"
echo -e "*******************************************************************************************************************"
tput setaf 2

mkdir ~/HAProxy

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Creating the HAProxy configuration in the current users home folder"
echo -e "*******************************************************************************************************************"
tput setaf 2

tee ~/HAProxy/HAProxy.cfg <<EOF
global
 log /dev/log local0
 log /dev/log local1 notice
 daemon

defaults
 log global
 mode tcp
 timeout connect 5000
 timeout client 50000
 timeout server 50000
frontend workers_https
 bind *:443
 mode tcp
 use_backend ingress_https
backend ingress_https
 option httpchk GET /healthz
 mode tcp
 server worker $worker1:443 check port 80
 server worker2 $worker2:443 check port 80
 server worker3 $worker3:443 check port 80

frontend workers_http
 bind *:80
 use_backend ingress_http
backend ingress_http
 mode http
 option httpchk GET /healthz
 server worker $worker1:80 check port 80
 server worker2 $worker2:80 check port 80
 server worker3 $worker3:80 check port 80

EOF

tput setaf 5
echo -e "\n*******************************************************************************************************************"
echo -e "Starting HAProxy Docker container"
echo -e "*******************************************************************************************************************"
tput setaf 2

echo -e "Worker 1: " $worker1
echo -e "Worker 2: " $worker2
echo -e "Worker 3: " $worker3
tput setaf 2

echo -e "\n\n"

# Start the HAProxy Container for the Worker Nodes
docker run --name HAProxy-workers-lb -d -p 80:80 -p 443:443 -v ~/HAProxy:/usr/local/etc/HAProxy:ro haproxy -f /usr/local/etc/HAProxy/HAProxy.cfg
