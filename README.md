# canarie-hyperledger-fabric
CANARIE DAIR Sample Solution
Preliminary steps to run on a Linux machine:
- Run install-bins.sh
- Go to folder "fabric-network"
- Run the following commands:
  - ./network.sh down
  - ./network.sh up -ca
  - ./network.sh createChannel -c trial
  - ./network.sh deployCC -ccn basic -ccp ../../fabric-samples/asset-transfer-basic/chaincode-javascript/ -ccl javascript -c trial

Assume we have a javascript chaincode in folder ../../fabric-samples/asset-transfer-basic/chaincode-javascript/
