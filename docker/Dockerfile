# Dockerfile
FROM seapy/rails-nginx-unicorn-pro:v1.0-ruby2.2.0-nginx1.6.0
MAINTAINER Meedan(hello@meedan.com)

# Add here other packages you need to install
RUN apt-get install vim -y

# Nginx config
ADD docker/nginx.conf /etc/nginx/sites-enabled/default

# Install Rails App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
ADD . /app
RUN bundle exec rake db:migrate

# Nginx port number
EXPOSE 80
