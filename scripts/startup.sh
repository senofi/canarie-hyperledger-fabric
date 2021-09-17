#!/bin/bash

###
# Startup script to set up GIT, clone the repository and start the process
###

apt-get update
apt-get install git

git clone -b ${1:-develop} https://github.com/senofi/canarie-hyperledger-fabric.git && \
    cd canarie-hyperledger-fabric && \
    ./scripts/install-bins.sh && \
    cd fabric-network && \
    ./network.sh down && \
    ./network.sh up -ca && \
    ./network.sh createChannel -c trial && \
    ./network.sh deployCC -ccn cctest -ccp ../clinical-trials-chaincode/ -ccl java -c trial && \
    docker-compose -f docker/docker-compose-web-apps.yaml up -d
