FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    apache2 \
    ruby \
    ruby-dev \
    build-essential \
    libapache2-mod-passenger \
    libmysqlclient-dev \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://redmine.org/releases/redmine-5.0.1.tar.gz \
    && tar -xvzf redmine-5.0.1.tar.gz \
    && ln -s redmine-5.0.1 redmine \
    && cd /opt/redmine
    
COPY database.yml config/database.yml

COPY application.rb config/application.rb

RUN gem install bundler && \
    echo "gem 'tzinfo-data'" >> Gemfile && \
    echo "gem 'rails-i18n'" >> Gemfile && \
    bundle install && \
    bundle exec rake generate_secret_token && \
    mkdir -p /opt/redmine-5.0.1/tmp/cache/ && \
    chmod -R 777 /opt/redmine-5.0.1/tmp/cache/ && \
    chown -R :www-data /opt/redmine-5.0.1/tmp/cache/

COPY redmine.conf /etc/apache2/sites-available/

RUN a2dissite 000-default.conf && \
    a2ensite redmine.conf && \
    service apache2 start

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
