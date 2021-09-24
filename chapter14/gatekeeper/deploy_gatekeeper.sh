#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/experimental/gatekeeper-mutation.yaml
kubectl create -f ../../chapter9/default_mutations.yaml
sh ../../chapter9/delete_all_pods_except_gatekeeper.sh
sh ../../chapter9/deploy_gatekeeper_psp_policies.sh
kubectl create -f ../../chapter9/multi-tenant/yaml/minimal_gatekeeper_constraints.yaml
kubectl apply -f ../../chapter9/multi-tenant/yaml/gatekeeper-config.yaml
kubectl create -f ../../chapter9/multi-tenant/yaml/require-psp-for-namespace-constrainttemplate.yaml
kubectl create -f ../../chapter9/multi-tenant/yaml/require-psp-for-namespace-constraint.yaml
