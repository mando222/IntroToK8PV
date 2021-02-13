
kubectl get nodes
kubectl get pods --all-namespaces
wget https://openebs.github.io/charts/openebs-operator.yaml
kubectl apply openebs-operator.yaml
kubectl get pods --all-namespaces

#Look at the drives we have connected to our boxes
lsblk -f


#Setup the Persistant Volume Claim
wget https://openebs.github.io/charts/examples/local-device/local-device-pvc.yaml
kubectl apply -f local-device-pvc.yaml
#Verify the PVC is in a pending state
kubectl get pvc local-device-pvc


#Next setup the pod
wget https://openebs.github.io/charts/examples/local-device/local-device-pod.yaml
kubectl apply -f local-device-pod.yaml


#Verify our configuration starting with our new pod
kubectl get pod hello-local-device-pod
#Verify the pod is using the Local PV Device we setup
kubectl describe pod hello-local-device-pod

# Look at the configuration of the Persistant Volume Claim
kubectl get pvc local-device-pvc
# Use the name id under the VOLUME column to return the current configuration
kubectl get pv YOURPVCID -o yaml

# Get the name of the block device
kubectl get bdc -n openebs bdc-YOURPVCID

# Look at the block device 
kubectl get bd -n openebs YOURBLOCKDEVICENAME -o yaml

#TODO access data

#delete everything and see it spun down
kubectl delete pod hello-local-device-pod
kubectl delete pvc local-device-pvc
kubectl delete sc local-device
kubectl get pv
#backup and restore https://docs.openebs.io/docs/next/uglocalpv-device.html#backup-and-restore
