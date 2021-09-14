VERSION=2.3.3
CA_VERSION=1.5.2
ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
MARCH=$(uname -m)
BINARY_FILE=hyperledger-fabric-${ARCH}-${VERSION}.tar.gz
CA_BINARY_FILE=hyperledger-fabric-ca-${ARCH}-${CA_VERSION}.tar.gz


curl -L --retry 5 --retry-delay 3 "https://github.com/hyperledger/fabric/releases/download/v${VERSION}/${BINARY_FILE}" | tar xz || rc=$?

curl -L --retry 5 --retry-delay 3 "https://github.com/hyperledger/fabric-ca/releases/download/v${CA_VERSION}/${CA_BINARY_FILE}" | tar xz || rc=$?
