#!/bin/bash

kubectl describe -n kubernetes-dashboard secret $(kubectl get secrets -n kubernetes-dashboard | grep admin-user | awk '{print $1}')
