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

COPY . /app
EXPOSE 3000
RUN printf "n\nn\nn\nn\nn\ny\npaypal\n\n\n" | RAILS_ENV=production rails g solidus:install
RUN RAILS_ENV=production rails db:migrate
RUN yarn install
RUN SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rails assets:precompile
RUN RAILS_ENV=production bundle exec rails webpacker:install
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]