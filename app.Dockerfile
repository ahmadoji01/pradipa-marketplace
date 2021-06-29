FROM ruby:2.7.3

RUN apt-get update -qq

RUN apt-get install -y curl \
    vim \
    wget \
    zip \
    unzip \
    build-essential \
    yarn \
    imagemagick \
    sqlite3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install NodeJS LTS
RUN sh -c "curl -sL https://deb.nodesource.com/setup_lts.x | bash -"
RUN apt install -y nodejs

# Install Yarn package
RUN rm -rf /usr/bin/yarn
RUN sh -c "npm install yarn --global"

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
RUN yarn install

COPY . /app
EXPOSE 3000
RUN RAILS_ENV=production rails db:migrate
RUN spring stop
RUN printf "n\nn\nn\nn\nn\ny\npaypal\nadmin@example.com\ntest123\n" | RAILS_ENV=production rails g solidus:install
RUN SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rake assets:precompile
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]