#!/bin/bash

for each in $(kubectl get ns -o jsonpath="{.items[*].metadata.name}" | grep -v gatekeeper-system);
do
  kubectl delete pods -n $each
done