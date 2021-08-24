
tput setaf 6
echo -e "\n \n*******************************************************************************************************************"
echo -e "Deploying K8GB Using the NYC Values file"
echo -e "*******************************************************************************************************************"
tput setaf 3

kubectl create ns k8gb
helm repo add k8gb https://www.k8gb.io
helm repo update
helm install k8gb k8gb/k8gb -n k8gb -f k8gb-nyc-values.yaml
