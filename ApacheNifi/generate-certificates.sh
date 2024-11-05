#!/bin/bash

# Set variables
HOSTNAME="compute-05.insight.gsu.edu"
KEYSTORE_PASSWORD="changeMe123!"
TRUSTSTORE_PASSWORD="changeMe123!"
DAYS_VALID=365

# Generate keystore
keytool -genkeypair -alias nifi-key -keyalg RSA -keysize 2048 -keystore keystore.jks \
  -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD \
  -validity $DAYS_VALID -dname "CN=$HOSTNAME, OU=NIFI" \
  -ext SAN=dns:$HOSTNAME,ip:127.0.0.1

# Generate truststore and add the certificate
keytool -exportcert -alias nifi-key -file nifi-cert.pem -keystore keystore.jks -storepass $KEYSTORE_PASSWORD
keytool -importcert -alias nifi-cert -file nifi-cert.pem -keystore truststore.jks -storepass $TRUSTSTORE_PASSWORD -noprompt

# Clean up
rm nifi-cert.pem

echo "Keystore and truststore generated successfully."
