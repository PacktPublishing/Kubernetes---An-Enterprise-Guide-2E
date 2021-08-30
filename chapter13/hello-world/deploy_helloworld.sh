#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

sed "s/IPADDR/$hostip/g" < ./hello-world.yaml > /tmp/hello-world.yaml

kubectl create -f /tmp/hello-world.yaml