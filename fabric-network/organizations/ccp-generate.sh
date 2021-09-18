#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function json_ccp_explorer {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-explorer-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=nova
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/nova.example.com/tlsca/tlsca.nova.example.com-cert.pem
CAPEM=organizations/peerOrganizations/nova.example.com/ca/ca.nova.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/nova.example.com/connection-nova.json
echo "$(json_ccp_explorer $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/nova.example.com/connection-nova-explorer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/nova.example.com/connection-nova.yaml

ORG=genh
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/genh.example.com/tlsca/tlsca.genh.example.com-cert.pem
CAPEM=organizations/peerOrganizations/genh.example.com/ca/ca.genh.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/genh.example.com/connection-genh.json
echo "$(json_ccp_explorer $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/genh.example.com/connection-genh-explorer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/genh.example.com/connection-genh.yaml

ORG=regulator
P0PORT=8051
CAPORT=6054
PEERPEM=organizations/peerOrganizations/regulator.example.com/tlsca/tlsca.regulator.example.com-cert.pem
CAPEM=organizations/peerOrganizations/regulator.example.com/ca/ca.regulator.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.example.com/connection-regulator.json
echo "$(json_ccp_explorer $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.example.com/connection-regulator-explorer.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/regulator.example.com/connection-regulator.yaml