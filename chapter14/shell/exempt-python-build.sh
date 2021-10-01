#!/bin/bash

kubectl patch K8sRequirePSPForNamespace k8srequirepspfornamespace --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spspdefaultallowprivilegeescalation --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spspdefaultallowprivilegeescalationinit --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spspfsgroup --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasnonroot --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasnonrootinit --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasgroup --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasgroupinit --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasuser --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spsprunasuserinit --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spspcapabilities --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'
kubectl patch Assign k8spspcapabilitiesinit --type=json -p '[{"op":"add","path":"/spec/match/excludedNamespaces/0","value":"python-hello-build"}]'