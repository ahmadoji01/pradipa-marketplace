class AddNameEmailToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_tickets, :name, :string
    add_column :spree_tickets, :email, :string
  end
end
