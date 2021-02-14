# TITLE HERE

##  DISCRIPTION HERE
This is a discription of the cool stuff we are going to do in the session today

Banner
<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

## Before starting
Workshop attendees will receave an email with the instance info prior to the workshop.

Notice that training cloud instances will be available only during the workshop and will be terminated **24 hours later**. If you are in our workshop we recommend using the provided cloud instance, you can relax as we have you covered: prerequisites are installed already.

**⚡ IMPORTANT NOTE:**
Everywhere in this repo you see `<YOURADDRESS>` replace with the URL for the instance you were given.  

## Table of content and resources

* [Workshop On YouTube](YOUTUBE LINK HERE)
* [Presentation](PDF OF SLIDES HERE)
* [Discord chat](DISCORD LINK HERE)

| Title  | Description
|---|---|
| **1 - Part 1** | [Instructions](#Part-1)  |
| **2 - Part 2** | [Instructions](#Part-2)  |
| **3 - Resources** | [Instructions](#Resources)  |



## 1. Getting Connected
**✅ Step 1a: The first step in the section.**


Screenshot of the above working
<img src="https://user-images.githubusercontent.com/blah/blahblah.png" width=“700” />

TODO

Once you have opened the terminal run
```bash
kubectl get nodes
```

*📃output*

```bash
NAME                        STATUS   ROLES    AGE   VERSION
learning-cluster-master     Ready    master   49m   v1.19.4
learning-cluster-worker-0   Ready    <none>   49m   v1.19.4
learning-cluster-worker-1   Ready    <none>   49m   v1.19.4
ubuntu@learning-cluster-master:~/workshop$ 
```
If you see the above output you are ready for the lab.

## 2. Setting up OpenEBS

kubectl get pods --all-namespaces
wget https://openebs.github.io/charts/openebs-operator.yaml
kubectl apply openebs-operator.yaml
kubectl get pods --all-namespaces



## 3. Create a Persistant Volume Claim
#Look at the drives we have connected to our boxes
lsblk -f


#Setup the Persistant Volume Claim
wget https://openebs.github.io/charts/examples/local-device/local-device-pvc.yaml
kubectl apply -f local-device-pvc.yaml
#Verify the PVC is in a pending state
kubectl get pvc local-device-pvc




## 4. Create a Pod and Attach the PVC



#Next setup the pod
wget https://openebs.github.io/charts/examples/local-device/local-device-pod.yaml
kubectl apply -f local-device-pod.yaml


#Verify our configuration starting with our new pod
kubectl get pod hello-local-device-pod
#Verify the pod is using the Local PV Device we setup
kubectl describe pod hello-local-device-pod


## 5. Verify Everything

# Look at the configuration of the Persistant Volume Claim
kubectl get pvc local-device-pvc
# Use the name id under the VOLUME column to return the current configuration
kubectl get pv YOURPVCID -o yaml

# Get the name of the block device
kubectl get bdc -n openebs bdc-YOURPVCID

# Look at the block device 
kubectl get bd -n openebs YOURBLOCKDEVICENAME -o yaml




## 6. Spin it All Down


#TODO access data

#delete everything and see it spun down
kubectl delete pod hello-local-device-pod
kubectl delete pvc local-device-pvc
kubectl delete sc local-device
kubectl get pv



## 7. Resources
For further reading go to the [OpenEBS Docs](https://docs.openebs.io/) 
Check out our new Discord server [Invite](https://discord.gg/kkDTVQwJSN) 
Get into more with the Data On Kubernetes Community [DOKc](https://dok.community/)
Many more workshops to come so Please subscribe to the YouTube Channel to be notified. 

