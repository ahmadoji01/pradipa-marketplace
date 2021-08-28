class AddBloggerAndProducerToRole < ActiveRecord::Migration[6.1]
  def change
    Spree::Role.find_or_create_by(name: 'blogger')
    Spree::Role.find_or_create_by(name: 'producer')
  end
end
