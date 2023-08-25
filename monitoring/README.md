# Monitoring and Logging Setup Guide

This guide provides step-by-step instructions for setting up a monitoring and logging solution using Kubernetes, Prometheus, Grafana, Elasticsearch, Logstash, and Kibana.

## Prerequisites

- Kubernetes cluster set up and `kubectl` configured
- Helm installed on your local machine

## Step 1: Deploy the Sample Application

Apply the Kubernetes manifest to deploy a sample application:

```shell
kubectl apply -f app-seamlesshr.yaml


Step 2: Set Up Prometheus and Grafana
Install Prometheus and Grafana using Helm charts:

# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack

# Grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana

Access Grafana via port-forwarding or set up an Ingress controller.
