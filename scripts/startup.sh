#!/bin/bash

#################################################################################
# Startup script to set up required prerequisites, clone the repository 
# and start the process for setting Hyperledger Fabric and the Sample Solution.
#################################################################################

apt-get update && \
    apt-get -y install git && \
    apt-get -y install docker.io && \
    apt-get -y install docker-compose

HLF_FOLDER=/opt/canarie/hyperledger-fabric
BRANCH=${1:-develop}
mkdir -p $HLF_FOLDER

echo "Cloning Git repository with branch: '$BRANCH'"
git clone -b $BRANCH https://github.com/senofi/canarie-hyperledger-fabric.git $HLF_FOLDER && \
    cd $HLF_FOLDER && \
    $HLF_FOLDER/scripts/install-bins.sh && \
    cd $HLF_FOLDER/fabric-network && \
    ./network.sh down && \
    ./network.sh up -ca && \
    ./network.sh createChannel -c trial && \
    ./network.sh deployCC -ccn cctest -ccp ../clinical-trials-chaincode/ -ccl java -c trial && \
    docker-compose -f docker/docker-compose-web-apps.yaml up -d && \
    echo "Installation Process Complete"
