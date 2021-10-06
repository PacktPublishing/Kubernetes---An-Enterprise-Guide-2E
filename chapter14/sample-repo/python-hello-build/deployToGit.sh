#!/bin/bash

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')

export destdir=$1

export appname=$2

mkdir -p $destdir/src/pipelineresources
mkdir -p $destdir/src/pipelines
mkdir -p $destdir/src/tasks


sed "s/IPADDR/$hostip/g" < src/pipelineresources/tekton-image-result.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/pipelineresources/tekton-image-result.yaml
sed "s/IPADDR/$hostip/g" < src/pipelines/tekton-pipeline.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/pipelines/tekton-pipeline.yaml
sed "s/IPADDR/$hostip/g" < src/tasks/tekton-task1.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/tasks/tekton-task1.yaml
sed "s/IPADDR/$hostip/g" < src/tasks/tekton-task2.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/tasks/tekton-task2.yaml
sed "s/IPADDR/$hostip/g" < src/tasks/tekton-task3.yaml | sed "s/APPNAME/$appname/g" > $destdir/src/tasks/tekton-task3.yaml
sed "s/example-pipeline/build-hello-pipeline/g" < $destdir/src/triggertemplates/gitlab-build-template.yaml  > /tmp/gitlab-build-template.yaml
cp /tmp/gitlab-build-template.yaml $destdir/src/triggertemplates/gitlab-build-template.yaml

cp README.md $destdir/

currdir=$(pwd)

cd $destdir
git add *
git commit -m 'initial commit'
git push

cd $currdir