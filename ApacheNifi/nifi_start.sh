#!/bin/bash
podman stop ${USER}_nifi
podman rm ${USER}_nifi
podman run --name ${USER}_nifi \
-v ./certs/localhost:/opt/certs \
-p 28080:8080 \
-p 28443:8443 \
-e AUTH=tls \
-e KEYSTORE_PATH=/opt/certs/keystore.jks \
-e KEYSTORE_TYPE=JKS \
-e KEYSTORE_PASSWORD=QKZv1hSWAFQYZ+WU1jjF5ank+l4igeOfQRp+OSbkkrs \
-e TRUSTSTORE_PATH=/opt/certs/truststore.jks \
-e TRUSTSTORE_PASSWORD="Rw0sqHR15KAwn4Jw4nVBrHw+FAFWhyu1lcrgrV90J/Q=" \
-e TRUSTSTORE_TYPE=JKS \
-e INITIAL_ADMIN_IDENTITY="CN=$HOSTNAME, OU=InstituteForInsight, O=GSU, C=US" \
-e NIFI_WEB_PROXY_CONTEXT_PATH=/nifi \
-e NIFI_WEB_PROXY_HOST=compute-05.insight.gsu.edu \
-d apache/nifi:1.5.0
podman ps
podman logs -f ${USER}_nifi
