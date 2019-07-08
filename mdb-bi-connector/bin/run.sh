#!/bin/bash

MONGO_URI="mongodb://${MONGO_HOST}:${MONGO_PORT}"
service rsyslog start
mkfifo mdb-bi-connector.log
tail -f mdb-bi-connector.log&
#Concatenate the cert and key together
cat ${SSL_KEY_FILE} >> /combined.pem
cat ${SSL_CERT_FILE} >> /combined.pem

echo /opt/mongodb-bi-linux-x86_64-debian92-v${BI_CONNECTOR_VERSION}/bin/mongosqld --sslMode ${SSL_MODE} --sslPemKeyFile /combined.pem --sslPEMKeyPassword ${SSL_KEY_PASS} --sslAllowInvalidCertificates --sslAllowInvalidHostnames --addr ${ADDR} --mongo-uri ${MONGO_URI} --auth --mongo-username ${SAMPLING_USER} --mongo-password ${SAMPLING_PASS} --logPath=mdb-bi-connector.log
/opt/mongodb-bi-linux-x86_64-debian92-v${BI_CONNECTOR_VERSION}/bin/mongosqld --sslMode ${SSL_MODE} --sslPemKeyFile /combined.pem --sslPEMKeyPassword ${SSL_KEY_PASS} --sslAllowInvalidCertificates --sslAllowInvalidHostnames --addr ${ADDR} --mongo-uri ${MONGO_URI} --auth --mongo-username ${SAMPLING_USER} --mongo-password ${SAMPLING_PASS} --logPath=mdb-bi-connector.log  --logAppend --logRotate reopen -vv

