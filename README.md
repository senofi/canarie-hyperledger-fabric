# Hyperledger Fabric Starter Package
Sample Solution of a Hyperledger Fabric Network, chaincode and web applications.

CANARIE DAIR Sample Solution
Preliminary steps to run on a Linux machine:
- Run ./scripts/install-bins.sh
- Go to folder "fabric-network"
- Run the following commands:
  - ./network.sh down
  - ./network.sh up -ca
  - ./network.sh createChannel -c trial
  - ./network.sh deployCC -ccn cctest -ccp ../clinical-trials-chaincode/ -ccl java -c trial
  - docker-compose -f docker/docker-compose-web-apps.yaml up -d

Open 3 browser tabs and use the credentials: user/pass

- http://localhost:8088/ - create a case as a hospital representative
- http://localhost:8089/ - investigate a case as a pharma processor
- http://localhost:8090/ - see the status as regulator


Assume we have a javascript chaincode in folder ../../fabric-samples/asset-transfer-basic/chaincode-javascript/

# How to Get Started

## Locally

## Cloud Provider

# License

All code and configuration in this repository (code files contained in this directory and all subdirectories) is licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

All documentation, media and images in this repository (non-code files contained in this directory and all subdirectories) are licensed under the [CC BY-NC License](https://creativecommons.org/licenses/by-nc/4.0/). 
