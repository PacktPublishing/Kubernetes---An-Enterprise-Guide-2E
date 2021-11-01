#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/experimental/gatekeeper-mutation.yaml

echo "sleeping 10 seconds"
sleep 10s

sh ../../chapter9/deploy_gatekeeper_psp_policies.sh

echo "sleeping 10 seconds"
sleep 10s


kubectl create -f ../../chapter9/default_mutations.yaml

echo "sleeping 10 seconds"
sleep 10s


sh ../../chapter9/delete_all_pods_except_gatekeeper.sh

echo "sleeping 10 seconds"
sleep 10s


kubectl create -f ../../chapter9/multi-tenant/yaml/minimal_gatekeeper_constraints.yaml

echo "sleeping 10 seconds"
sleep 10s



kubectl apply -f ../../chapter9/multi-tenant/yaml/gatekeeper-config.yaml

echo "sleeping 10 seconds"
sleep 10s


kubectl create -f ../../chapter9/multi-tenant/yaml/require-psp-for-namespace-constrainttemplate.yaml

echo "sleeping 10 seconds"
sleep 10s


kubectl create -f ../../chapter9/multi-tenant/yaml/require-psp-for-namespace-constraint.yaml
