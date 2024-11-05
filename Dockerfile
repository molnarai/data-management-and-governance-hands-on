FROM apache/nifi:latest

# Install OpenJDK for keytool
USER root
RUN apt-get update && apt-get install -y openjdk-21-jdk
USER nifi

# Copy the certificate generation script
COPY generate-certificates.sh /opt/nifi/nifi-current/
RUN chmod +x /opt/nifi/nifi-current/generate-certificates.sh

# Generate certificates
RUN /opt/nifi/nifi-current/generate-certificates.sh

# Configure NiFi to use SSL
RUN echo "nifi.web.https.port=8433" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.web.https.host=compute-05.insight.gsu.edu" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.keystore=/opt/nifi/nifi-current/keystore.jks" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.keystoreType=JKS" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.keystorePasswd=changeMe123!" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.keyPasswd=changeMe123!" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.truststore=/opt/nifi/nifi-current/truststore.jks" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.truststoreType=JKS" >> /opt/nifi/nifi-current/conf/nifi.properties && \
    echo "nifi.security.truststorePasswd=changeMe123!" >> /opt/nifi/nifi-current/conf/nifi.properties

# Expose the HTTPS port
EXPOSE 28433
