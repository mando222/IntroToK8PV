# Introduction to Persistent Storage on Kubernetes

## DESCRIPTION
There are a few ways to handle data persistence on Kubernetes.  Today we will dive into configuration of the OSS OpenEBS project. 

## Before starting
Workshop attendees will receive an email with the instance info prior to the workshop.

Notice that training cloud instances will be available only during the workshop and will be terminated **12-24 hours later**. If you are in our workshop, we recommend using the provided cloud instance; we have you covered: the prerequisites are installed.

**⚡ IMPORTANT NOTE:**
Everywhere in this repository you see `<YOURADDRESS>` replace with the URL for the instance you were given.  

## Table of content and resources
* [Presentation](PDF OF SLIDES HERE)
* [Discord chat](https://discord.gg/kkDTVQwJSN)

| Title  | Description
|---|---|
| **1 - Getting Connected** | [Instructions](#1-Getting-Connected)  |
| **2 - Setting up OpenEBS** | [Instructions](#2-Setting-up-OpenEBS)  |
| **3 - Create a Storage Class** | [Instructions](#3-Create-a-Storage-Class)  |
| **4 - Create a Persistent Volume Claim** | [Instructions](#4-Create-a-Persistent-Volume-Claim)  |
| **5 - Create a Pod and Attach the PVC** | [Instructions](#5-Create-a-Pod-and-Attach-the-PVC)  |
| **6 - Verify Everything** | [Instructions](#6-Verify-Everything)  |
| **7 - Spin it All Down** | [Instructions](#7-Spin-it-All-Down)  |
| **8 - Resources** | [Instructions](#8-Resources)  |



## 1. Getting Connected
**✅ Step 1a: The first step in the section.**

In your browser window, navigate to the url <YOURADDRESS>:3000 where your address is the one emailed to you before the session.
  
When you arrive at the webpage you should be greeted by something similar to this.
<img src="https://user-images.githubusercontent.com/1936716/107884421-a23fe180-6eba-11eb-96d2-4c703ccb1dcf.png" width=“700” />

Click in the `Terminal` menu from the top of the page and select new terminal as shown below
<img src="https://user-images.githubusercontent.com/1936716/107884506-09f62c80-6ebb-11eb-9f7b-42bdb3444cc1.png" width=“700” />

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

*📃output*

```bash
NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system   coredns-f9fd979d6-fbhvf                           1/1     Running   0          97m
kube-system   coredns-f9fd979d6-p95s2                           1/1     Running   0          97m
kube-system   etcd-learning-cluster-master                      1/1     Running   0          97m
kube-system   kube-apiserver-learning-cluster-master            1/1     Running   0          97m
kube-system   kube-controller-manager-learning-cluster-master   1/1     Running   0          97m
kube-system   kube-flannel-ds-kg2rb                             1/1     Running   0          96m
kube-system   kube-flannel-ds-kjhh5                             1/1     Running   0          96m
kube-system   kube-flannel-ds-ztdjh                             1/1     Running   0          96m
kube-system   kube-proxy-nrqmf                                  1/1     Running   0          97m
kube-system   kube-proxy-p45s8                                  1/1     Running   0          97m
kube-system   kube-proxy-stqtm                                  1/1     Running   0          97m
kube-system   kube-scheduler-learning-cluster-master            1/1     Running   0          97m
```

**✅ Step 2: Get the operator yaml file and deploy it.**
```bash
wget https://openebs.github.io/charts/openebs-operator.yaml
kubectl apply -f openebs-operator.yaml
```

**✅ Step 3: Check to see the new OpenEBS pods.**
```bash
kubectl get pods --all-namespaces
```

*📃output*

```bash
namespace/openebs created
serviceaccount/openebs-maya-operator created
...
clusterrolebinding.rbac.authorization.k8s.io/openebs-maya-operator created
deployment.apps/maya-apiserver created
service/maya-apiserver-service created
deployment.apps/openebs-provisioner created
deployment.apps/openebs-snapshot-operator created
configmap/openebs-ndm-config created
daemonset.apps/openebs-ndm created
deployment.apps/openebs-ndm-operator created
deployment.apps/openebs-admission-server created
deployment.apps/openebs-localpv-provisioner created
```

## 3. Create a Storage Class

**✅ Step 1: Setup the Storage Class.**
```bash
wget https://openebs.github.io/charts/examples/local-device/local-device-ps.yaml
kubectl apply -f local-device-sc.yaml
```

*📃output*

```bash
storageclass.storage.k8s.io/local-device created
```
**✅ Step 2: Verify the Storage Class created.**
```bash
kubectl get sc local-device
```

*📃output*

```bash
local-device   openebs.io/local   Delete          WaitForFirstConsumer   false                  57s
```

## 4. Create a Persistent Volume Claim

**✅ Step 1: Look at the drives we have connected to our node.**
```bash
ssh worker0
lsblk -f
```

*📃output*

```bash
NAME        FSTYPE   LABEL           UUID                                 MOUNTPOINT
loop0       squashfs                                                      /snap/core/9993
loop1       squashfs                                                      /snap/amazon-ssm-agent
loop2       squashfs                                                      /snap/core/10823
loop3       squashfs                                                      /snap/core18/1988
loop4       squashfs                                                      /snap/amazon-ssm-agent
nvme1n1                                                                   
nvme0n1                                                                   
└─nvme0n1p1 ext4     cloudimg-rootfs 4dc427d0-74d1-4d90-a452-2cfdb7538e46 /
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

*📃output*

```bash
persistentvolumeclaim/local-device-pvc created
```
**✅ Step 3: Verify the PVC is in a pending state.**
```bash
kubectl get pvc local-device-pvc
```

*📃output*

```bash
NAME               STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
local-device-pvc   Pending                                      local-device   30s
```

## 5. Create a Pod and Attach the PVC

**✅ Step 1: Setup the pod.**
```bash
wget https://openebs.github.io/charts/examples/local-device/local-device-pod.yaml
kubectl apply -f local-device-pod.yaml
```

*📃output*

```bash
pod/hello-local-device-pod created
```
**✅ Step 2: Verify our configuration starting with our new pod.**
```bash
kubectl get pod hello-local-device-pod
```

*📃output*

```bash
```

**✅ Step 3: Verify the pod is using the Local PV Device we setup.**
```bash
kubectl describe pod hello-local-device-pod
```

## 6. Verify Everything

**✅ Step 1: Look at the configuration of the Persistant Volume Claim.**
```bash
kubectl get pvc local-device-pvc
```

*📃output*

```bash
```

**✅ Step 2: Check your PVC configuration.**

Use the id under the VOLUME column in the output of the previous step in place of YOURPVCID
```bash
kubectl get pv YOURPVCID -o yaml
```

*📃output*

```bash
```

**✅ Step 3: Get the name of the block device.**
```bash
kubectl get bdc -n openebs bdc-YOURPVCID
```

*📃output*

```bash
```
**✅ Step 4: Check the block device config.**
```bash
kubectl get bd -n openebs YOURBLOCKDEVICENAME -o yaml
```

*📃output*

```bash
```

## 7. Spin it All Down

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
*📃output*

```bash
```

## 8. Resources
For further reading go to the [OpenEBS Docs](https://docs.openebs.io/) 
Check out our new Discord server [Invite](https://discord.gg/kkDTVQwJSN) 
Get into more with the Data On Kubernetes Community [DOKc](https://dok.community/)
Many more workshops to come so Please subscribe to the YouTube Channel to be notified. 

