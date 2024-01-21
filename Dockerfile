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
    && ln -s redmine-5.0.1 redmine

WORKDIR /opt/redmine
COPY database.yml config/database.yml

COPY application.rb config/application.rb

RUN gem install bundler

RUN echo "gem 'tzinfo-data'" >> Gemfile && bundle install

RUN echo "gem 'rails-i18n'" >> Gemfile && bundle install

RUN bundle exec rake generate_secret_token

#RUN RAILS_ENV=production bundle exec rake db:migrate

#RUN RAILS_ENV=production bundle exec rake redmine:load_default_data

RUN chmod -R 777 /opt/redmine-5.0.1/tmp/cache/ && \
    chown -R :www-data /opt/redmine-5.0.1/tmp/cache/ && \
    mkdir -p /opt/redmine-5.0.1/tmp/cache/ && \
    chmod -R 777 /opt/redmine-5.0.1/tmp/cache/

COPY redmine.conf /etc/apache2/sites-available/

RUN a2dissite 000-default.conf

RUN a2ensite redmine.conf

RUN service apache2 start

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
