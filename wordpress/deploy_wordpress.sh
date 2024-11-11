#!/bin/bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install my-release /root/wordpress-chart