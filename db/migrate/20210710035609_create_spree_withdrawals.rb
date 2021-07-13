class CreateSpreeWithdrawals < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_withdrawals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bank_name
      t.string :bank_swift_code
      t.string :bank_country

      t.timestamps
    end
  end
end
