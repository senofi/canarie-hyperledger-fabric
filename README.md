# Hyperledger Fabric Starter Package
Sample Solution of a Hyperledger Fabric Network, chaincode and web applications.

CANARIE DAIR Sample Solution

Prerequisites for this solution to work are Docker, Docker Compose and Git.

## How to Get Started

### Locally

Steps to run on a Linux machine (the solution has been tested on Ubuntu):
- Run ./scripts/install-bins.sh
- Go to folder "fabric-network"
- Run the following commands:
  - ./network.sh down
  - ./network.sh up -ca
  - ./network.sh createChannel -c trial
  - ./network.sh deployCC -ccn cctest -ccp ../clinical-trials-chaincode/ -ccl java -c trial
  - IMAGE_TAG=develop docker-compose -f docker/docker-compose-web-apps.yaml up -d
  - docker-compose -f docker/docker-compose-hlf-explorer.yaml up -d
  - docker-compose -f docker/docker-compose-nginx.yaml up -d

### Vagrant

The sample solution could be installed locally using a [Vagrant|https://www.vagrantup.com/] virtual machine (VM). The default provider that Vagrant relies on is [VirtualBox|https://www.virtualbox.org/]. Make sure that both of them are installed locally before proceeding.

To get the VM up and running simply run `vagrant up` in the root folder. This will run the default branch set up (main). To run against a specific branch run `BRANCH=<branch-name> vagrant up`.

### Cloud Provider

We support Canarie DAIR Cloud and you can find more information on our BoosterPack and others [here|https://www.canarie.ca/cloud/boosterpacks/].
The only limitation for any other cloud provider is that the operating system is Ubuntu 20.04 or above.

## How to Use the Application

Open a browser and go to http://localhost where are the links to the applications' landing pages.
To login to the regulator, nova and general hospital applications use the following credentials: `user/pass`

To view the blockchain transactions click on the blockchain explorer link on the landing page.
- http://localhost/explorer - HLF blockcahin explorer (credentials: `admin/adminpw`)

# License

All code and configuration in this repository (code files contained in this directory and all subdirectories) is licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).

All documentation, media and images in this repository (non-code files contained in this directory and all subdirectories) are licensed under the [CC BY-NC License](https://creativecommons.org/licenses/by-nc/4.0/). 
