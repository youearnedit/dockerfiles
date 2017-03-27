This repo contains base docker images for rails apps.

Here's an example of how to use passenger-rails2.3 to build a rails app:

```
FROM youearnedit/passenger-rails2.3:latest

# Switch to the root user for the install
USER root

# Install app dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      # For sqlite
      libsqlite3-dev \
      # For nokogiri
      zlib1g-dev \
      liblzma-dev \
 && rm -rf /var/lib/apt/lists/*

# Add app code
COPY . $APP_HOME

# Install Gem dependencies
RUN bundle install

# Precompile assets
RUN RAILS_ENV=production rake assets:precompile

# Whole app owned by docker user
RUN chown -R docker:docker $APP_HOME

# Switch to docker user and Go!
USER docker
CMD ["/usr/src/entrypoint.sh"]
```