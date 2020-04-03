#!/bin/bash

kubectl apply -f namespace-elasticsearch.yaml 
kubectl apply -f elasticsearch-master.yaml -n nm-elasticsearch
kubectl apply -f elasticsearch-workers.yaml -n nm-elasticsearch

