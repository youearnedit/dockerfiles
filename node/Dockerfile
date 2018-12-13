#Base on Node Alpine
FROM node:10-alpine



#Use tini to make node respond correctly to signals
RUN apk add --no-cache tini
USER node
ENTRYPOINT ["/sbin/tini", "--"]

# Run node under Tini
CMD ["/usr/local/bin/node"]