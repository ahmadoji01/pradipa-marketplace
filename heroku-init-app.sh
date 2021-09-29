heroku run (bundle check || bundle install) &&
heroku run printf "n\nn\nn\nn\nn\ny\npaypal\n" | RAILS_ENV=production rails generate solidus:install --migrate=false --sample=false --seed=false &&
heroku run RAILS_ENV=production bundle exec rails db:drop &&
heroku run RAILS_ENV=production bundle exec rails db:create &&
heroku run RAILS_ENV=production rails railties:install:migrations &&
heroku run RAILS_ENV=production rails db:migrate &&
heroku run printf "\n\n" | RAILS_ENV=production rails db:seed &&
heroku run SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rails assets:precompile &&
heroku run RAILS_ENV=production bundle exec rails webpacker:install &&
heroku run bin/spring stop &&
heroku run RAILS_ENV=production rails spree_sample:load &&
heroku run rm -rf tmp/latest.dump