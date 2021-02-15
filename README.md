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

**✅ Step 3: Check to see the new OpenEBS pods.**
```bash
kubectl get pods --all-namespaces
```

*📃output*

```bash
NAMESPACE     NAME                                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-f9fd979d6-ln2v7                             1/1     Running   0          9m49s
kube-system   coredns-f9fd979d6-qmddk                             1/1     Running   0          9m49s
kube-system   etcd-learning-cluster-0-master                      1/1     Running   0          10m
kube-system   kube-apiserver-learning-cluster-0-master            1/1     Running   0          10m
kube-system   kube-controller-manager-learning-cluster-0-master   1/1     Running   0          10m
kube-system   kube-flannel-ds-bf4fw                               1/1     Running   0          2m40s
kube-system   kube-flannel-ds-lzwfg                               1/1     Running   0          2m40s
kube-system   kube-flannel-ds-sklwv                               1/1     Running   0          2m40s
kube-system   kube-proxy-4n8z5                                    1/1     Running   0          3m
kube-system   kube-proxy-f8kf2                                    1/1     Running   0          2m47s
kube-system   kube-proxy-ld922                                    1/1     Running   0          9m49s
kube-system   kube-scheduler-learning-cluster-0-master            1/1     Running   0          10m
openebs       maya-apiserver-64b7cfd966-ts7wg                     0/1     Running   3          74s
openebs       openebs-admission-server-dfcc899d4-kq6lq            1/1     Running   0          73s
openebs       openebs-localpv-provisioner-7f5c4cd4cf-kkvgl        1/1     Running   0          73s
openebs       openebs-ndm-9cdcx                                   1/1     Running   0          73s
openebs       openebs-ndm-flt9m                                   1/1     Running   0          73s
openebs       openebs-ndm-operator-85bb97d5f7-x5bkq               1/1     Running   0          73s
openebs       openebs-provisioner-fc4f45bbb-rvv69                 1/1     Running   0          74s
openebs       openebs-snapshot-operator-856d75cbb9-vj2r6          2/2     Running   0          74s
```

## 3. Create a Storage Class

**✅ Step 1: Look at the drives we have connected to our nodes.**
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

**✅ Step 1: Tag Block Devices.**

First we need to see what block devices we have access to.  

```bash 
kubectl get blockdevice -n openebs
```
*📃output*

```bash
NAME                                           NODENAME                      SIZE          CLAIMSTATE   STATUS   AGE
blockdevice-00a153d28d33527f7614abfeb2700329   learning-cluster-0-worker-0   75000000000   Unclaimed    Active   66m
blockdevice-0b4e70565b4d5193724c1c97e59d9ed2   learning-cluster-0-worker-1   75000000000   Unclaimed    Active   66m
```

```bash
kubectl label bd -n openebs BLOCKDEVICENAMEHERE openebs.io/block-device-tag=learning
kubectl label bd -n openebs BLOCKDEVICENAMEHERE openebs.io/block-device-tag=learning
```

**✅ Step 2: Setup the Storage Class.**
```bash
kubectl apply -f local-device-sc.yaml
```

*📃output*

```bash
storageclass.storage.k8s.io/local-device created
```
**✅ Step 3: Verify the Storage Class created.**


```bash
kubectl get sc local-device
```

*📃output*

```bash
NAME           PROVISIONER        RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-device   openebs.io/local   Delete          WaitForFirstConsumer   false                  4m28s
```

## 4. Create a Persistent Volume Claim


**✅ Step 1: Setup the Persistant Volume Claim.**
```bash
wget https://openebs.github.io/charts/examples/local-device/local-device-pvc.yaml
kubectl apply -f local-device-pvc.yaml
```

*📃output*

```bash
persistentvolumeclaim/local-device-pvc created
```
**✅ Step 2: Verify the PVC is in a pending state.**
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
NAME                     READY   STATUS    RESTARTS   AGE
hello-local-device-pod   1/1     Running   0          2m55s
```

**✅ Step 3: Verify the pod is using the Local PV Device we setup.**
```bash
kubectl describe pod hello-local-device-pod
```

*📃output*

```bash
Name:         hello-local-device-pod
Namespace:    default
Priority:     0
Node:         learning-cluster-0-worker-0/10.0.1.66
Start Time:   Mon, 15 Feb 2021 05:43:23 +0000
Labels:       <none>
Annotations:  <none>
Status:       Running
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m34s  default-scheduler  Successfully assigned default/hello-local-device-pod to learning-cluster-0-worker-0
  Normal  Pulling    3m34s  kubelet            Pulling image "busybox"
  Normal  Pulled     3m33s  kubelet            Successfully pulled image "busybox" in 608.838949ms
  Normal  Created    3m33s  kubelet            Created container hello-container
  Normal  Started    3m33s  kubelet            Started container hello-container
```

## 6. Verify Everything

**✅ Step 1: Look at the configuration of the Persistant Volume Claim.**
```bash
kubectl get pvc local-device-pvc
```

*📃output*

```bash
NAME               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
local-device-pvc   Bound    pvc-1d1e53c2-897e-48dc-aeb3-485bc2a593a6   5G         RWO            local-device   4m41s
```

**✅ Step 2: Check your PVC configuration.**

Use the id under the VOLUME column in the output of the previous step in place of YOURPVCID
```bash
kubectl get pv YOURPVCID -o yaml
```

*📃output*

```bash
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    local.openebs.io/blockdeviceclaim: bdc-pvc-1d1e53c2-897e-48dc-aeb3-485bc2a593a6
    pv.kubernetes.io/provisioned-by: openebs.io/local
  creationTimestamp: "2021-02-15T05:43:22Z"
  finalizers:
  - kubernetes.io/pv-protection
...
status:
  phase: Bound
```

**✅ Step 3: Get the name of the block device.**
```bash
kubectl get bdc -n openebs bdc-YOURPVCID
```

*📃output*

```bash
NAME                                           BLOCKDEVICENAME                                PHASE   AGE
bdc-pvc-1d1e53c2-897e-48dc-aeb3-485bc2a593a6   blockdevice-00a153d28d33527f7614abfeb2700329   Bound   10m
```
**✅ Step 4: Check the block device config.**
```bash
kubectl get bd -n openebs YOURBLOCKDEVICENAME -o yaml
```

*📃output*

```bash
apiVersion: openebs.io/v1alpha1
kind: BlockDevice
metadata:
  annotations:
    internal.openebs.io/uuid-scheme: gpt
  creationTimestamp: "2021-02-15T04:30:10Z"
  finalizers:
  - openebs.io/bd-protection
  generation: 2
  labels:
    kubernetes.io/hostname: learning-cluster-0-worker-0
    ndm.io/blockdevice-type: blockdevice
    ndm.io/managed: "true"
    openebs.io/block-device-tag: learning
  managedFields:
  - apiVersion: openebs.io/v1alpha1
...
  devlinks:
  - kind: by-id
    links:
    - /dev/disk/by-id/nvme-Amazon_EC2_NVMe_Instance_Storage_AWS283E87F715A24F5CC
    - /dev/disk/by-id/nvme-nvme.1d0f-4157533238334538374637313541323446354343-416d617a6f6e20454332204e564d6520496e7374616e63652053746f72616765-00000001
  - kind: by-path
    links:
    - /dev/disk/by-path/pci-0000:00:1f.0-nvme-1
  filesystem: {}
  nodeAttributes:
    nodeName: learning-cluster-0-worker-0
  partitioned: "No"
  path: /dev/nvme1n1
status:
  claimState: Claimed
  state: Active
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
No resources found
```

## 8. Resources
For further reading go to the [OpenEBS Docs](https://docs.openebs.io/) 
Check out our new Discord server [Invite](https://discord.gg/kkDTVQwJSN) 
Get into more with the Data On Kubernetes Community [DOKc](https://dok.community/)
Many more workshops to come so Please subscribe to the YouTube Channel to be notified. 

