# YouEarnedIt Ops ops@youearnedit.com
#  Base Dockerfile

FROM ubuntu:xenial-20210804

# Upgrade and install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apt-transport-https \
      build-essential \
      ca-certificates \
      curl \
      git \
      language-pack-en \
      locales \
      gnupg2 \
      psmisc \
      python-pip \
      unzip \
      python-setuptools \
      software-properties-common \
      sudo \
 && rm -rf /var/lib/apt/lists/*

# Setup the docker user
RUN addgroup --gid 9999 docker \
 && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
 && usermod -L docker

# Setup the locale options
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
RUN dpkg-reconfigure locales

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install


# Become the docker user
USER docker
