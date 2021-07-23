#!/bin/bash

for each in $(kubectl get ns | tail -n +2 | awk '{print $1}' | grep -v gatekeeper-system);
do
  echo "$each"
  kubectl delete pods --all -n "$each"
done