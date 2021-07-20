class AddUserReferenceToTicket < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_tickets, :user
  end
end
