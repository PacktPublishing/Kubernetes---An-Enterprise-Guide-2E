#!/bin/bash

for constraint in $(kubectl get crds | grep 'constraints.gatekeeper.sh' | awk '{print $1}');
do      
        echo "$constraint $(kubectl get $constraint -o json | jq -r 'status.totalViolations')"
done