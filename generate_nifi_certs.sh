#!/bin/bash

# Set variables
HOSTNAME="compute-05.insight.gsu.edu"
KEYSTORE_PASSWORD="QKZv1hSWAFQYZ+WU1jjF5ank+l4igeOfQRp+OSbkkrs"
TRUSTSTORE_PASSWORD=$(openssl rand -base64 32)
VALIDITY_DAYS=365
# CERT_DIR="/User/dreynolds/certs/localhost"
CERT_DIR="./certs/localhost"

# Create directory if it doesn't exist
mkdir -p "$CERT_DIR"

# Generate keystore
keytool -genkeypair -alias nifi-key -keyalg RSA -keysize 2048 -keystore "$CERT_DIR/keystore.jks" \
  -storepass "$KEYSTORE_PASSWORD" -keypass "$KEYSTORE_PASSWORD" \
  -validity $VALIDITY_DAYS -dname "CN=$HOSTNAME, OU=InstituteForInsight, O=GSU, C=US" \
  -ext SAN=dns:$HOSTNAME,ip:127.0.0.1

# Export the certificate
keytool -exportcert -alias nifi-key -file "$CERT_DIR/nifi-cert.pem" -keystore "$CERT_DIR/keystore.jks" -storepass "$KEYSTORE_PASSWORD"

# Import the certificate into a new truststore
keytool -importcert -alias nifi-cert -file "$CERT_DIR/nifi-cert.pem" -keystore "$CERT_DIR/truststore.jks" \
  -storepass "$TRUSTSTORE_PASSWORD" -noprompt

# Clean up the temporary certificate file
rm "$CERT_DIR/nifi-cert.pem"

echo "Keystore and truststore have been generated in $CERT_DIR"
echo "Keystore password: $KEYSTORE_PASSWORD"
echo "Truststore password: $TRUSTSTORE_PASSWORD"

# Save the truststore password to a file
echo "$TRUSTSTORE_PASSWORD" > "$CERT_DIR/truststore_password.txt"
echo "Truststore password has been saved to $CERT_DIR/truststore_password.txt"
