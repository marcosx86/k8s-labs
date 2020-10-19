#!/bin/bash

kubectl apply -f elasticsearch-namespace.yaml 
kubectl apply -f elasticsearch-master.yaml -n nm-elasticsearch
kubectl apply -f elasticsearch-workers.yaml -n nm-elasticsearch
kubectl apply -f kibana.yaml -n nm-elasticsearch
kubectl apply -f lmenezes-cerebro.yaml -n nm-elasticsearch

