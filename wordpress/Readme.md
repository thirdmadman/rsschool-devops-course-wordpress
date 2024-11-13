# Simple WordPress helm chart

## Overview

This software part of task5 to with WordPress helm chart.

To deploy this WordPress helm chart you need running cluster, which can be deployed with from task3 folder with infrastructure terraform scripts [Folder with terraform scripts](https://github.com/thirdmadman/rsschool-devops-course-tasks/tree/task-5/task_3)

### Prerequisites

To deploy WordPress with this repo on your cluster, you need to have a running cluster with the following components:

- 1x bastion/nat host in public subnet
- 1x main node with K3S cluster in private subnet
- Kubernetes 1.23+ on main node with K3S cluster
- Helm 3.8.0+ on main node with K3S cluster

Also you need to have a private keys for the bastion host and the main node, user names for this keys and public IP address of bastion/nat and private IP address of main node.

### Installing manually

#### Connect to main node

To install this chart on your Kubernetes cluster with helm, you need to connect to the main node of the cluster using ssh via basion/nat instance.

To do this use following command on Linux machine:
```bash
ssh -A -J ec2-user@<ec2_nat_gw_instance_public_ip> ec2-user@<ec2_k3s_main_instance_private_ip>
```

Same exact command can be used in Windows machine via XSHELL (free for personal use).

#### Clone the repository

To clone the repository, run the following command:
```bash
git clone https://github.com/USERNAME/REPOSITORY.git
```

Navigate to the cloned repository directory and run the following commands:

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install my-wp-release ./wordpress
```

This will install the Wordpress Helm chart and mark it's as my-wp-release in helm.

### Installing via CI/CD

#### Prepare the environment

To install the software part of task5, follow these steps:

Deploy infrastructure from [Folder with terraform scripts](https://github.com/thirdmadman/rsschool-devops-course-tasks/tree/task-5/task_3)

Obtain the public IP address of bastion/nat host and private IP address of main node from the output of terraform of the task3.

example of terraform output:

```bash
ec2_k3s_main_instance_private_ip = "10.0.3.10"
ec2_nat_gw_instance_private_ip = "10.0.1.133"
ec2_nat_gw_instance_public_ip = "16.171.116.246"
```

Add the GH secrets to this repository:

- SSH_IP_BASTION - Public IP address of bastion/nat host
- SSH_IP_MAIN_NODE - Private IP address of main node
- SSH_PRIVATE_KEY_BASION - Private key of bastion/nat host
- SSH_PRIVATE_KEY_MAIN_NODE - Private key of main node
- SSH_USER_BASTION - Username of bastion/nat host
- SSH_USER_MAIN_NODE - Username of main node

To set up these secrets, follow these steps:

#### Set up Github Secrets

1. Log in to your Github account and navigate to your repository.
2. Click on the "Settings" icon (looks like a gear) next to your repository name.
3. Select "Actions" from the left-hand menu.
4. Scroll down to the "Secrets" section.
5. Click on the "New secret" button.
6. Enter the following secrets and their corresponding values for the list above

#### Run GHA workflow manually

1. Click on the "Actions" tab.
2. Find and click on "Github Actions workflow for deployment wordpress on k3s cluster"
3. Find and click on button "Run workflow" in action section.

#### Verification

To verify that deployment is successful open previous Github Actions workflow and check the status of the workflow.

Then open logs of the "Deploy wordpress job" and check if step "Connect and execute script on remote host via jump host" contains the following messages:

```bash
NAME: my-wp-release
LAST DEPLOYED: Mon Nov 11 23:30:37 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NAME         	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                	APP VERSION
my-wp-release	default  	1       	2024-11-11 23:30:37.260483158 +0000 UTC	deployed	wordpress-chart-0.1.0	6.6.2      
NAMESPACE     NAME                                      READY   STATUS              RESTARTS        AGE     IP          NODE                                       NOMINATED NODE   READINESS GATES
default       mysql-7b67787964-g6psz                    0/1     ContainerCreating   0               2s      <none>      ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
default       wordpress-c4c775c5c-dtcwd                 0/1     ContainerCreating   0               2s      <none>      ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   coredns-7b98449c4-sf7wl                   1/1     Running             6 (3m1s ago)    4h22m   10.42.0.5   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   helm-install-traefik-crd-5b9zl            0/1     Completed           0               4h22m   10.42.0.3   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   helm-install-traefik-gc7sb                0/1     Completed           2               4h22m   10.42.0.6   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   local-path-provisioner-595dcfc56f-v9sxr   1/1     Running             0               4h22m   10.42.0.4   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   metrics-server-cdcc87586-dnqhf            1/1     Running             8 (2m26s ago)   4h22m   10.42.0.2   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   svclb-traefik-9385b5d0-gz95k              2/2     Running             0               4h22m   10.42.0.7   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
kube-system   traefik-d7c9c5778-xp7g7                   1/1     Running             5 (3m25s ago)   4h22m   10.42.0.8   ip-10-0-3-10.eu-north-1.compute.internal   <none>           <none>
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP        4h23m
mysql        ClusterIP   10.43.230.176   <none>        3306/TCP       4s
wordpress    NodePort    10.43.8.125     <none>        80:32000/TCP   4s
```

Some information could vary depending on the cluster, but you should be able to see the mysql and wordpress pods are running and wordpress service is up and running on NodePort 32000.

After this application will be deployed in several minuets and you will be able to see the WP page in your browse by accessing public IP address of basion host on port 80 (basically http).

So link to the WP page will be: http//<ec2_nat_gw_instance_public_ip>

