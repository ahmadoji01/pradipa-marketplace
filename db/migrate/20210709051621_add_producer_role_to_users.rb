class AddProducerRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    Spree::Role.create!(:name => "producer") unless Spree::Role.where(:name => "producer").any?
  end
end
