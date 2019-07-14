#!/bin/bash

# Generate a random string
PASS=$(openssl rand -base64 12)

CA_CERTIFICATES_DIR=/usr/share/ca-certificates/safelocalhost

TEMP_DIR=$PWD/temp
ROOT_KEY=$TEMP_DIR/root_key.key
ROOT_CRT=$TEMP_DIR/root_crt.crt
SERVER_CSR=$TEMP_DIR/server.csr
SERVER_KEY=$TEMP_DIR/server.key
SERVER_CRT=$TEMP_DIR/server.crt
PEM=$TEMP_DIR/public_certificate.pem
CNF_SETTINGS=$TEMP_DIR/cnf_settings.cnf
V3_SETTINGS=$TEMP_DIR/v3_settings.ext


# Directories
# ..................................................................................................................................................................
mkdir -p $TEMP_DIR
if [[ ! -e $CA_CERTIFICATES_DIR ]]; then
    sudo mkdir -p $CA_CERTIFICATES_DIR
fi


# Create a new OpenSSL configuration
# ..................................................................................................................................................................
cat > $CNF_SETTINGS << EOL
[req]
default_bits=2048
prompt=no
default_md=sha256
distinguished_name=dn
days=1024

[dn]
C=VE
ST=ACME STATE
L=ACME CITY
O=ACME
OU=ACME DEV
emailAddress=acme@industries.com
CN=localhost
EOL

# Create a X509 v3 certificate configuration file. Notice how we’re specifying subjectAltName here.
# ..................................................................................................................................................................
cat > $V3_SETTINGS << EOL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.localhost
DNS.2 = localhost
EOL

# CREATE ROOT KEY
# ..................................................................................................................................................................
openssl genpkey -aes-256-cbc -algorithm RSA -out $ROOT_KEY -pkeyopt rsa_keygen_bits:4096  -pass pass:$PASS

# CREATE PEM
# ..................................................................................................................................................................
openssl req -x509 -new -nodes -key $ROOT_KEY -sha256 -days 1024 -out $PEM -config <( cat $CNF_SETTINGS ) -passin pass:$PASS

# CREATE ROOT CRT
# ..................................................................................................................................................................
openssl x509 -in $PEM -inform PEM -out $ROOT_CRT

# MOVE ROOT CRT TO CERTIFICATES_HOME
# ..................................................................................................................................................................
sudo cp $ROOT_CRT $CA_CERTIFICATES_DIR

# INSTALL ROOT CRT
# ..................................................................................................................................................................
sudo update-ca-certificates

# ..................................................................................................................................................................
#
#   Server Client   
#
# ..................................................................................................................................................................

# Create a certificate key for localhost.
# ..................................................................................................................................................................
openssl req -new -sha256 -nodes -out $SERVER_CSR -newkey rsa:2048 -keyout $SERVER_KEY -config <( cat $CNF_SETTINGS ) 

#  A certificate signing request is issued via the root SSL certificate we created earlier to create a domain certificate for localhost. The output is a certificate file called server.crt.
# ..................................................................................................................................................................
openssl x509 -req -in $SERVER_CSR -CA $PEM -CAkey $ROOT_KEY -CAcreateserial -out $SERVER_CRT -days 500 -sha256 -extfile $V3_SETTINGS -passin pass:$PASS
