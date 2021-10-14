#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

export destdir=$1
export appname=$2


mkdir -p $destdir/src/deployments

sed "s/IPADDR/$hostip/g" < src/deployments/hello-python.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/deployments/hello-python.yaml

cp README.md $destdir/

currdir=$(pwd)

cd $destdir
git add *
git commit -m 'initial commit'
git push

cd $currdir