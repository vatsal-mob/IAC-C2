#!/bin/bash
curl -sSL https://get.docker.com/ | sh && sleep 5
apt install -y git && sleep 5
cd /root/ && git clone --recurse-submodules https://github.com/cobbr/Covenant && sleep 5
docker build -t covenant /root/Covenant/Covenant/ && sleep 5
docker run -d -p 7443:7443 -p 80:80 -p 443:443 --name covenant -v /root/Covenant/Covenant/Data/:/app/Data covenant && sleep 5