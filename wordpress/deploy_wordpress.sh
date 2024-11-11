#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install my-wp-release /root/wordpress-chart
helm list
kubectl get pods -o wide --all-namespaces
kubectl get svc