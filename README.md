# Introduction to Persistent Storage on Kubernetes

## DISCRIPTION
There are a few ways to handle data persistance on Kubernetes.  Today we will dive in to configuration of the OSS OpenEBS project. 

## Before starting
Workshop attendees will receave an email with the instance info prior to the workshop.

Notice that training cloud instances will be available only during the workshop and will be terminated **12-24 hours later**. If you are in our workshop we recommend using the provided cloud instance, we have you covered: the prerequisites are installed.

**⚡ IMPORTANT NOTE:**
Everywhere in this repo you see `<YOURADDRESS>` replace with the URL for the instance you were given.  

## Table of content and resources
* [Presentation](PDF OF SLIDES HERE)
* [Discord chat](https://discord.gg/kkDTVQwJSN)

| Title  | Description
|---|---|
| **1 -  Getting Connected** | [Instructions](#1-Getting-Connected)  |
| **2 - Setting up OpenEBS** | [Instructions](#2-Setting-up-OpenEBS)  |
| **3 - Create a Persistant Volume Claim** | [Instructions](#3-Create-a-Persistant-Volume-Claim)  |
| **4 - Create a Pod and Attach the PVC** | [Instructions](#4-Create-a-Pod-and-Attach-the-PVC)  |
| **5 - Verify Everything** | [Instructions](#5-Verify-Everything)  |
| **6 - Spin it All Down** | [Instructions](#6-Spin-it-All-Down)  |
| **7 - Resources** | [Instructions](#7-Resources)  |



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
**✅ Step 1: Check what Pods are running currently.**
```bash
kubectl get pods --all-namespaces
```
**✅ Step 2: Get the operator yaml file and deploy it.**
```bash
wget https://openebs.github.io/charts/openebs-operator.yaml
kubectl apply openebs-operator.yaml
```
**✅ Step 3: Check to see the new OpenEBS pods.**
```bash
kubectl get pods --all-namespaces
```

## 3. Create a Persistant Volume Claim

**✅ Step 1: Look at the drives we have connected to our node.**
```bash
ssh worker0
lsblk -f
```
Notice the NVMe drives connected.  To exit the worker node simply run
```bash
exit
```

**✅ Step 2: Setup the Persistant Volume Claim.**
```bash
wget https://openebs.github.io/charts/examples/local-device/local-device-pvc.yaml
kubectl apply -f local-device-pvc.yaml
```

**✅ Step 3: Verify the PVC is in a pending state.**
```bash
kubectl get pvc local-device-pvc
```

## 4. Create a Pod and Attach the PVC

**✅ Step 1: Setup the pod.**
```bash
wget https://openebs.github.io/charts/examples/local-device/local-device-pod.yaml
kubectl apply -f local-device-pod.yaml
```

**✅ Step 2: Verify our configuration starting with our new pod.**
```bash
kubectl get pod hello-local-device-pod
```

**✅ Step 3: Verify the pod is using the Local PV Device we setup.**
```bash
kubectl describe pod hello-local-device-pod
```

## 5. Verify Everything

**✅ Step 1: Look at the configuration of the Persistant Volume Claim.**
```bash
kubectl get pvc local-device-pvc
```

**✅ Step 2: Check your PVC configuration.**
Use the id under the VOLUME column in the output of the previous step in place of YOURPVCID
```bash
kubectl get pv YOURPVCID -o yaml
```

**✅ Step 3: Get the name of the block device.**
```bash
kubectl get bdc -n openebs bdc-YOURPVCID
```

**✅ Step 4: Check the block device config.**
```bash
kubectl get bd -n openebs YOURBLOCKDEVICENAME -o yaml
```

## 6. Spin it All Down

#TODO access data

**✅ Step 1: Delete everything.**
```bash
kubectl delete pod hello-local-device-pod
kubectl delete pvc local-device-pvc
kubectl delete sc local-device
```

**✅ Step 2: Check the PV.**
```bash
kubectl get pv
```

## 7. Resources
For further reading go to the [OpenEBS Docs](https://docs.openebs.io/) 
Check out our new Discord server [Invite](https://discord.gg/kkDTVQwJSN) 
Get into more with the Data On Kubernetes Community [DOKc](https://dok.community/)
Many more workshops to come so Please subscribe to the YouTube Channel to be notified. 

