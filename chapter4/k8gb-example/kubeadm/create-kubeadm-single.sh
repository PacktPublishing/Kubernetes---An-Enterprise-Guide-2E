#!/bin/bash

# Note: The scripts provided in this repo are provided with a best effort to create a single Kubeadm cluster that can be used
#       to test K8GB in your infrastructure.  The decision to use a single node cluster was to limit any resource requirements
#       for readers.  You will need at least two Kubeadm clusters, and a access to your main DNS server to create the K8GB Zone
#       and the edgeDNS servers in the main DNS Zone.
#
#       This script is only meant to be used to test K8GB - since we only have a single node cluster, we need to remove the
#       noSchedule taint from the node to run other workloads like NGINX and K8GB.

clear
tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Creating Kubeadm Cluster"
echo -e "*******************************************************************************************************************"
tput setaf 3

# Enable Bridge
tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 1: Enabling Bridging"
echo -e "*******************************************************************************************************************"
tput setaf 3

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 2: Downloading Kubeadm and all required files"
echo -e "*******************************************************************************************************************"
tput setaf 3

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt install -y kubelet=1.21.4-00 kubeadm=1.21.4-00 kubectl=1.21.4-00

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 3: Switching the Docker driver"
echo -e "*******************************************************************************************************************"
tput setaf 3

# Switch Driver
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 4: Disabling the Hosts swap file"
echo -e "*******************************************************************************************************************"
tput setaf 3

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 5: Creating Kubeadm Single node cluster using a POD CIDR of 10.240.0.0/16, and Removing noschedule taint"
echo -e "*******************************************************************************************************************"
tput setaf 3

sudo kubeadm init --pod-network-cidr=10.240.0.0/16 --kubernetes-version=1.21.4

# Copy kube config to users home
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl taint node --all node-role.kubernetes.io/master-

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 6: Install Calico from local file, using 10.240.0.0/16 as the pod CIDR"
echo -e "*******************************************************************************************************************"
tput setaf 3
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f calico.yaml

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 7: Downloading and Installing HELM"
echo -e "*******************************************************************************************************************"
tput setaf 3

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Step 8: Installing NGINX Ingress Controller"
echo -e "*******************************************************************************************************************"
tput setaf 3

kubectl apply -f nginx-deploy.yaml
#kubectl create ns ingress-nginx
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
#helm repo update
#helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx

tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Kubeadm Cluster creation completed..."
echo -e "*******************************************************************************************************************/n"
tput setaf 3

