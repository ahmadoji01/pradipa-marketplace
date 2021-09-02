docker-compose run --rm web bash -c '
    bin/spring stop &&
    RAILS_ENV=production rails spree_sample:load
'