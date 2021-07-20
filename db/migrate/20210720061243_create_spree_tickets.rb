class CreateSpreeTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_tickets do |t|
      t.string :title
      t.string :status
      t.string :body
      t.string :picture

      t.timestamps
    end
  end
end
