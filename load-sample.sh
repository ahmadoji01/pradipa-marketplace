docker-compose run app bash -c 'bin/spring stop'
docker-compose run app bash -c 'RAILS_ENV=production rails spree_sample:load'