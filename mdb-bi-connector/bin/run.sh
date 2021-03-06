#!/bin/bash

set -m

MONGO_URI="mongodb://${MONGO_HOST}:${MONGO_PORT}/"


echo "starting connector application"
#Concatenate the cert and key together
cat ${SSL_CERT_FILE} >> combined.pem
cat ${SSL_KEY_FILE} >> combined.pem

echo "Mongo URI: $MONGO_URI"
# create log file so tail will work even if it's not created immediately
touch mdb-bi-connector.log
/opt/mongodb-bi-linux-x86_64-debian92-v${BI_CONNECTOR_VERSION}/bin/mongosqld --addr ${ADDR} --sslMode ${SSL_MODE} --sslPEMKeyFile /combined.pem --mongo-uri ${MONGO_URI} --auth --mongo-username ${SAMPLING_USER} --mongo-password ${SAMPLING_PASS} --logPath=mdb-bi-connector.log  --logAppend --logRotate reopen -vv ${EXTRA_OPTS} &
tail -f mdb-bi-connector.log &

fg %1
