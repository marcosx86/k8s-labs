#!/bin/bash

kubectl delete -f elasticsearch-workers.yaml -n nm-elasticsearch
kubectl delete -f elasticsearch-master.yaml -n nm-elasticsearch
kubectl delete -f namespace-elasticsearch.yaml 

