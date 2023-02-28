#!/bin/bash
helm repo add metallb https://metallb.github.io/metallb
helm upgrade -i -n metallb-system --create-namespace metallb metallb/metallb --atomic
