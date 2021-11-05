#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_NOVA_CA=${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/ca.crt
export PEER0_REGULATOR_CA=${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/ca.crt
export PEER0_GENH_CA=${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="nova"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_NOVA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="genh"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_GENH_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="regulator"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_REGULATOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.nova.example.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.genh.example.com:9051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.regulator.example.com:8051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    #CA=PEER0_ORG$1_CA
    if [ $1 -eq 1 ]; then
      CA=PEER0_NOVA_CA
    elif [ $1 -eq 2 ]; then
      CA=PEER0_GENH_CA
    elif [ $1 -eq 3 ]; then
      CA=PEER0_REGULATOR_CA
    elif [ $1 -eq 4 ]; then
      CA=PEER0_REGULATOR_CA
    else
      errorln "ORG Unknown"
    fi
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
