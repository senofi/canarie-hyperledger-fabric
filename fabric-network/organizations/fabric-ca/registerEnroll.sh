#!/bin/bash

function createNova() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/nova.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/nova.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-nova --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-nova.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-nova.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-nova.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-nova.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/nova.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-nova --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-nova --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-nova --id.name novaadmin --id.secret novaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-nova -M "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/msp" --csr.hosts peer0.nova.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/nova.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-nova -M "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls" --enrollment.profile tls --csr.hosts peer0.nova.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/nova.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/nova.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/nova.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/nova.example.com/tlsca/tlsca.nova.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/nova.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/nova.example.com/peers/peer0.nova.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/nova.example.com/ca/ca.nova.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-nova -M "${PWD}/organizations/peerOrganizations/nova.example.com/users/User1@nova.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/nova.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/nova.example.com/users/User1@nova.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://novaadmin:novaadminpw@localhost:7054 --caname ca-nova -M "${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/nova/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/nova.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp/config.yaml"

  cp "${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp/keystore/"* "${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp/keystore/key.key"

  chmod 444 "${PWD}/organizations/peerOrganizations/nova.example.com/users/Admin@nova.example.com/msp/keystore/key.key"

}


function createRegulator() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/regulator.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/regulator.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca-regulator --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-regulator.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-regulator.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-regulator.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-regulator.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-regulator --id.name regulatoradmin --id.secret regulatoradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-regulator -M "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/msp" --csr.hosts peer0.regulator.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:6054 --caname ca-regulator -M "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls" --enrollment.profile tls --csr.hosts peer0.regulator.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulator.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/tlsca/tlsca.regulator.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulator.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/peers/peer0.regulator.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/ca/ca.regulator.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:6054 --caname ca-regulator -M "${PWD}/organizations/peerOrganizations/regulator.example.com/users/User1@regulator.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulator.example.com/users/User1@regulator.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://regulatoradmin:regulatoradminpw@localhost:6054 --caname ca-regulator -M "${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/regulator/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp/config.yaml"

  cp "${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp/keystore/"* "${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp/keystore/key.key"

  chmod 444 "${PWD}/organizations/peerOrganizations/regulator.example.com/users/Admin@regulator.example.com/msp/keystore/key.key"

}

function createGenh() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/genh.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/genh.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-genh --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-genh.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-genh.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-genh.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-genh.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/genh.example.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-genh --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-genh --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-genh --id.name genhadmin --id.secret genhadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-genh -M "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/msp" --csr.hosts peer0.genh.example.com --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/genh.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-genh -M "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls" --enrollment.profile tls --csr.hosts peer0.genh.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/genh.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/genh.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/genh.example.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/genh.example.com/tlsca/tlsca.genh.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/genh.example.com/ca"
  cp "${PWD}/organizations/peerOrganizations/genh.example.com/peers/peer0.genh.example.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/genh.example.com/ca/ca.genh.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-genh -M "${PWD}/organizations/peerOrganizations/genh.example.com/users/User1@genh.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/genh.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/genh.example.com/users/User1@genh.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://genhadmin:genhadminpw@localhost:8054 --caname ca-genh -M "${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/genh/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/genh.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp/config.yaml"

  cp "${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp/keystore/"* "${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp/keystore/key.key"

  chmod 444 "${PWD}/organizations/peerOrganizations/genh.example.com/users/Admin@genh.example.com/msp/keystore/key.key"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp" --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls" --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
