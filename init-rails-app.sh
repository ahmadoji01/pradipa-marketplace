docker-compose run --rm app bash -c '
  bin/wait-for-services &&
  (bundle check || bundle install) &&
  printf "n\nn\nn\nn\nn\ny\npaypal\n" | RAILS_ENV=production rails generate solidus:install --migrate=false --sample=false --seed=false &&
  RAILS_ENV=production bundle exec rails db:drop &&
  RAILS_ENV=production bundle exec rails db:create &&
  RAILS_ENV=production rails railties:install:migrations &&
  RAILS_ENV=production rails db:migrate &&
  printf "\n\n" | RAILS_ENV=production rails db:seed &&
  SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rails assets:precompile &&
  RAILS_ENV=production bundle exec rails webpacker:install
  rm -rf tmp/latest.dump
'