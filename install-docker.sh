#!/bin/bash

apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
mkdir -p /etc/docker/
mkdir /etc/systemd/system/docker.service.d
cat > /etc/docker/daemon.json <<EOF
{
"bip": "172.31.0.1/16",
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
apt-get install docker-ce docker-ce-cli containerd.io -y

