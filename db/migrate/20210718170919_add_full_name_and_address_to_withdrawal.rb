class AddFullNameAndAddressToWithdrawal < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_withdrawals, :full_name, :string
    add_column :spree_withdrawals, :address, :string
  end
end
