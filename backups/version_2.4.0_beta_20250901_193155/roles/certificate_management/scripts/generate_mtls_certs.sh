#!/bin/bash

# Script to generate internal CA and service certificates for mTLS
# Usage: ./generate_mtls_certs.sh <service_name> <domain>

set -e

SERVICE_NAME=$1
DOMAIN=$2
CERT_DIR="/etc/traefik/certs"
CA_DIR="$CERT_DIR/ca"

# Create directories if they don't exist
mkdir -p "$CA_DIR"
mkdir -p "$CERT_DIR"

# Generate CA private key and certificate if they don't exist
if [ ! -f "$CA_DIR/ca.key" ]; then
    echo "Generating CA private key and certificate..."
    openssl genrsa -out "$CA_DIR/ca.key" 4096
    openssl req -x509 -new -nodes -key "$CA_DIR/ca.key" -sha256 -days 3650 -out "$CA_DIR/ca.crt" \
        -subj "/CN=Internal CA/O=Homelab/C=US"
fi

# Generate service private key
echo "Generating private key for $SERVICE_NAME..."
openssl genrsa -out "$CERT_DIR/$SERVICE_NAME.key" 2048

# Generate CSR
echo "Generating CSR for $SERVICE_NAME..."
openssl req -new -key "$CERT_DIR/$SERVICE_NAME.key" \
    -out "$CERT_DIR/$SERVICE_NAME.csr" \
    -subj "/CN=$SERVICE_NAME.$DOMAIN/O=Homelab/C=US"

# Create certificate config
cat > "$CERT_DIR/$SERVICE_NAME.cnf" << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = $SERVICE_NAME.$DOMAIN
O = Homelab
C = US

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $SERVICE_NAME.$DOMAIN
DNS.2 = $SERVICE_NAME
EOF

# Sign certificate
echo "Signing certificate for $SERVICE_NAME..."
openssl x509 -req -in "$CERT_DIR/$SERVICE_NAME.csr" \
    -CA "$CA_DIR/ca.crt" -CAkey "$CA_DIR/ca.key" \
    -CAcreateserial -out "$CERT_DIR/$SERVICE_NAME.crt" \
    -days 365 -sha256 \
    -extfile "$CERT_DIR/$SERVICE_NAME.cnf" \
    -extensions v3_req

# Clean up
rm "$CERT_DIR/$SERVICE_NAME.csr" "$CERT_DIR/$SERVICE_NAME.cnf"

# Set permissions
chmod 600 "$CERT_DIR/$SERVICE_NAME.key"
chmod 644 "$CERT_DIR/$SERVICE_NAME.crt"

echo "Certificate generation complete for $SERVICE_NAME"
echo "Certificate: $CERT_DIR/$SERVICE_NAME.crt"
echo "Private key: $CERT_DIR/$SERVICE_NAME.key"
echo "CA certificate: $CA_DIR/ca.crt" 