#Variables
RESOURCE_GROUP="traefik-aks"
LOCATION="northeurope"
AKS_NAME="traefik-demo"

#Create resource group
az group create -n $RESOURCE_GROUP -l $LOCATION

# Create AKS cluster
az aks create -n $AKS_NAME -g $RESOURCE_GROUP --node-count 1 --generate-ssh-keys

#Get the context for the new AKS
az aks get-credentials -n $AKS_NAME -g $RESOURCE_GROUP

#You will need to authorize Traefik to use the Kubernetes API
#RoleBindings per namespace enable to restrict granted permissions to the very namespaces only that Traefik 
#is watching over, thereby following the least-privileges principle. This is the preferred approach if Traefik 
#is not supposed to watch all namespaces, and the set of namespaces does not change dynamically. Otherwise, 
#a single ClusterRoleBinding must be employed.
kubectl apply -f cluster-role.yaml
kubectl apply -f cluster-role-binding.yaml

#Deploy Traefik using a Deployment or DaemonSet
kubectl apply -f service-account.yaml
kubectl apply -f daemon-set.yaml
kubectl apply -f service.yaml

kubectl --namespace=kube-system get pods


