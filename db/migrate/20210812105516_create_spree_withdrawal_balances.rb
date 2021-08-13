class CreateSpreeWithdrawalBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_withdrawal_balances do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance
      t.decimal :shipping
      t.decimal :tax
      t.decimal :total

      t.timestamps
    end
  end
end
