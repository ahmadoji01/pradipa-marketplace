class AddLineItemToWdBalance < ActiveRecord::Migration[6.1]
  def change
    add_reference :spree_withdrawal_balances, :line_item, foreign_key: { to_table: :spree_line_items }
  end
end
