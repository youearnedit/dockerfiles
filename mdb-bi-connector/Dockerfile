FROM debian:stretch
MAINTAINER Matthias Granberry <matthias.granberry@youearnedit.com>
ENV BI_CONNECTOR_VERSION=2.10.0

RUN apt-get update
RUN apt-get install -y openssl libgssapi-krb5-2 rsyslog


ADD https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-debian92-v$BI_CONNECTOR_VERSION.tgz /opt/
RUN tar xzvf /opt/mongodb-bi-linux-x86_64-debian92-v$BI_CONNECTOR_VERSION.tgz -C /opt
ADD bin /usr/local/bin
RUN chmod -R 755 /usr/local/bin
RUN chmod -R 755 /opt

EXPOSE 3307
CMD ["run.sh"]