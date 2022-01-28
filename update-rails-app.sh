docker-compose run --rm app bash -c '
    RAILS_ENV=production bundle exec rails assets:clean &&
    RAILS_ENV=production bundle exec rails assets:precompile &&
    RAILS_ENV=production bundle exec rails db:migrate'
docker-compose restart app
docker-compose restart nginx