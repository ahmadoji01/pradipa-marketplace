docker-compose run app bash -c 'SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rails assets:precompile'
docker-compose run app bash -c 'RAILS_ENV=production bundle exec rails webpacker:install'