class CreateSpreeWithdrawalRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_withdrawal_requests do |t|
      t.references :withdrawal, null: false, foreign_key: { to_table: :spree_withdrawals }
      t.decimal :balance, precision: 10, scale: 2, null: false
      t.string :status

      t.timestamps
    end
  end
end
