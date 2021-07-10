class CreateSpreeWithdrawalRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_withdrawal_requests do |t|
      t.references :withdrawal, null: false, foreign_key: true
      t.number :balance
      t.string :status

      t.timestamps
    end
  end
end
