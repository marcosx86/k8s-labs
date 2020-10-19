#!/bin/bash

kubectl delete -f lmenezes-cerebro.yaml -n nm-elasticsearch
kubectl delete -f kibana.yaml -n nm-elasticsearch
kubectl delete -f elasticsearch-workers.yaml -n nm-elasticsearch
kubectl delete -f elasticsearch-master.yaml -n nm-elasticsearch
kubectl delete -f elasticsearch-namespace.yaml 

