set -e

printf "n\nn\nn\nn\nn\ny\npaypal\n" | RAILS_ENV=production rails generate solidus:install --migrate=false --sample=false --seed=false
RAILS_ENV=production rails railties:install:migrations
RAILS_ENV=production rails db:migrate
printf "\n\n" | RAILS_ENV=production rails db:seed
RAILS_ENV=production rails spree_sample:load  
RAILS_ENV=production yarn install
SECRET_KEY_BASE=1 RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails webpacker:install
bundle exec puma -C config/puma.rb

exec "$@"