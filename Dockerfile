FROM ruby-2.7.3

RUN apk add --update --virtual /
  sqlite3 \
  imagemagick \
  nodejs \
  yarn \
  git \
  tzdata \
  file \
  build-base \
  libxml2-dev \
  libxslt-dev \
  libc-dev \
  linux-headers \
  && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/

ENV BUNDLE_PATH /gems
RUN yarn install
RUN bundle install

ENTRYPOINT ["bin/rails"]
CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000
