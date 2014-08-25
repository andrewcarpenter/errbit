FROM phusion/passenger-ruby20
MAINTAINER Andrew Carpenter <andrew@criticaljuncture.org>

# Set correct environment variables.
ENV HOME /root
ENV RAILS_ENV production

EXPOSE 80

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# install dependencies
RUN apt-get -qq update &&\
  apt-get install -y libxml2 libxml2-dev libxslt-dev libcurl4-openssl-dev &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/app
ADD Gemfile /home/app/Gemfile
ADD Gemfile.lock /home/app/Gemfile.lock
RUN bundle install --without development test

RUN rm -f /etc/service/nginx/down
ADD docker/passenger.conf /etc/nginx/sites-enabled/default
ADD docker/passenger-env.conf /etc/nginx/main.d/env.conf

# Startup scripts
ADD docker/startup /etc/my_init.d/
RUN chmod +x /etc/my_init.d/*

ADD . /home/app/
RUN chown -R app:app -R /home/app &&\
  chmod -R g+x,o+x /home/app

RUN su app -c "bundle exec rake assets:precompile"
