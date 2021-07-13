docker-compose run app bash -c 'RAILS_ENV=production bundle exec rails assets:clean'
docker-compose run app bash -c 'RAILS_ENV=production bundle exec rails assets:precompile'
docker-compose run app bash -c 'RAILS_ENV=production bundle exec rails db:migrate'
docker-compose restart nginx