#!/bin/bash

if [[ -z "${TS_REPO_NAME}" ]]; then
	REPO_NAME="tremolo"
else
	REPO_NAME=$TS_REPO_NAME
fi

echo "Helm Repo Name $REPO_NAME"

if [[ -z "${TS_REPO_URL}" ]]; then
	REPO_URL="https://nexus.tremolo.io/repository/helm"
else
	REPO_URL=$TS_REPO_URL
fi

echo "Helm Repo URL $REPO_URL"





echo "Deploying the Kubernetes Dashboard"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

echo "Deploying ActiveDirectory (ApacheDS)"

kubectl apply -f ../../chapter5/apacheds.yaml

while [[ $(kubectl get pods -l app=apacheds -n activedirectory -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for apacheds to be running" && sleep 1; done

echo "Adding helm repo"

helm repo add $REPO_NAME $REPO_URL
helm repo update


echo "Creating openunison namespace"

kubectl create ns openunison


echo "Pre-configuring OpenUnison LDAP"

kubectl create -f ../../chapter5/myvd-book.yaml

echo "Deploying the OpenUnison Operator"

helm install openunison $REPO_NAME/openunison-operator --namespace openunison 

echo "Creating the orchestra-secrets-source"

kubectl create -f - <<EOF
apiVersion: v1
type: Opaque
metadata:
   name: orchestra-secrets-source
   namespace: openunison
data:
   K8S_DB_SECRET: c3RhcnQxMjM=
   unisonKeystorePassword: cGFzc3dvcmQK
   AD_BIND_PASSWORD: c3RhcnQxMjM=
   OU_JDBC_PASSWORD: c3RhcnR0MTIz
   SMTP_PASSWORD: ZG9lc25vdG1hdHRlcg==
kind: Secret
EOF


echo "Waiting for the operator to be running"

while [[ $(kubectl get pods -l app=openunison-operator -n openunison -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for operator to br running" && sleep 1; done


echo "Generating helm chart values to /tmp/openunison-values.yaml"

export hostip=$(hostname  -I | cut -f1 -d' ' | sed 's/[.]/-/g')


sed "s/IPADDR/$hostip/g" < ./openunison-values.yaml  > /tmp/openunison-values.yaml

echo "Deploying Orchestra"

helm install orchestra $REPO_NAME/orchestra --namespace openunison -f /tmp/openunison-values.yaml

echo "Waiting for Orchestra to be running"

while [[ $(kubectl get pods -l app=openunison-orchestra -n openunison -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for orchestra to be running" && sleep 1; done

echo "Sleeping for 10 seconds to let openunison catch up...."

sleep 10s

echo "Deploying the login portal"

helm install orchestra-login-portal $REPO_NAME/orchestra-login-portal --namespace openunison -f /tmp/openunison-values.yaml


kubectl create -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
   name: ou-cluster-admins
subjects:
- kind: Group
  name: cn=k8s-cluster-admins,ou=Groups,DC=domain,DC=com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

echo "OpenUnison is deployed!"


