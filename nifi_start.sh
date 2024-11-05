#!/bin/bash
podman stop ${USER}_nifi
podman rm ${USER}_nifi
podman run --name ${USER}_nifi \
-v ./certs/localhost:/opt/certs \
-p 28443:8443 \
-e AUTH=tls \
-e KEYSTORE_PATH=/opt/certs/keystore.jks \
-e KEYSTORE_TYPE=JKS \
-e KEYSTORE_PASSWORD=QKZv1hSWAFQYZ+WU1jjF5ank+l4igeOfQRp+OSbkkrs \
-e TRUSTSTORE_PATH=/opt/certs/truststore.jks \
-e TRUSTSTORE_PASSWORD="Rw0sqHR15KAwn4Jw4nVBrHw+FAFWhyu1lcrgrV90J/Q=" \
-e TRUSTSTORE_TYPE=JKS \
-e INITIAL_ADMIN_IDENTITY="CN=$HOSTNAME, OU=InstituteForInsight, O=GSU, C=US" \
-d apache/nifi:latest