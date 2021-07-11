class AddBankNumberToWithdrawal < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_withdrawals, :bank_number, :string
  end
end
