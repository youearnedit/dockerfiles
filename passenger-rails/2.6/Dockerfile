# YouEarnedIt Ops ops@youearnedit.com
#  PassengerRails 2.6 Dockerfile

FROM gcr.io/kazoo-infrastructure/ubuntu:d3fb20fb65d4abdb177911d5908a1d45981f89a8


# Set important vars
ENV APP_HOME /usr/src/app/
ENV RUBY_VERSION 2.6
ENV BUNDLER_VERSION 1.17.3
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 10.x
ENV NPM_VERSION 6.14.1
ENV YARN_VERSION 1.22.19

# We'll have to do most of the install with root
USER root

# Create the app directory with perms
RUN mkdir -p ${APP_HOME}
RUN chown docker:docker ${APP_HOME}
WORKDIR ${APP_HOME}

## ---- Ruby, Gem and Bundler Install ----

# Install ruby, and rails deps
RUN apt-add-repository -y ppa:brightbox/ruby-ng \
 && apt-get update \
 && apt-get install -y \
      ruby${RUBY_VERSION} \
      ruby${RUBY_VERSION}-dev \
      # Rails timezone sources
      tzdata \
 && rm -rf /var/lib/apt/lists/*

# Install and setup bundler
RUN gem install -i /var/lib/gems/${RUBY_VERSION}.0 bundler -v ${BUNDLER_VERSION}
ENV BUNDLE_APP_CONFIG /home/docker/.bundle

# Setup the gem env as the docker user
USER docker
RUN echo "gem: --no-document" >> /home/docker/.gemrc \
 && mkdir -p /home/docker/.gem/ruby/${RUBY_VERSION}.0/build_info \
             /home/docker/.gem/ruby/${RUBY_VERSION}.0/cache \
             /home/docker/.gem/ruby/${RUBY_VERSION}.0/doc \
             /home/docker/.gem/ruby/${RUBY_VERSION}.0/extensions \
             /home/docker/.gem/ruby/${RUBY_VERSION}.0/gems \
             /home/docker/.gem/ruby/${RUBY_VERSION}.0/specifications
ENV GEM_HOME /home/docker/.gem/ruby/${RUBY_MAJOR}.0
ENV PATH ${GEM_HOME}/bin:${PATH}
USER root

## ---- Node Install ----

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && apt-get install -y nodejs \
 && npm install -g npm@"${NPM_VERSION}"

## ---- Yarn Install ----

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y yarn=${YARN_VERSION}\* \
 && rm -rf /var/lib/apt/lists/*

## ---- Passenger Install ----

# Install Passenger with Nginx
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
 && echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main" > /etc/apt/sources.list.d/passenger.list \
 && apt-get update \
 && apt-get install -y nginx-extras passenger libnginx-mod-http-passenger \
 && rm -rf /var/lib/apt/lists/*

# Setup Passenger native support as the docker user
USER docker
RUN passenger-config build-native-support
USER root

# Setup Nginx configuration
RUN mkdir -p /usr/src/nginx/conf.d \
             /usr/src/nginx/location.d \
             /usr/src/nginx/main.d
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY main.d/* /usr/src/nginx/main.d/

RUN if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
RUN ls /etc/nginx/conf.d/mod-http-passenger.conf

# Ensure Nginx config dir owned by the docker user
RUN chown docker:docker -R /usr/src/nginx

# Link stderr / stdout to nginx error / access logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

## ---- Setup final things and run ----

# Setup entrypoint script
COPY entrypoint.sh /usr/src/entrypoint.sh
CMD ["/usr/src/entrypoint.sh"]

# Become the docker user and GO!
USER docker
EXPOSE 8080
