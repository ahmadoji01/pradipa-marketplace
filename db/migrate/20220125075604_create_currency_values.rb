class CreateCurrencyValues < ActiveRecord::Migration[6.1]
  def change
    create_table :currency_values do |t|
      t.text :currency_from
      t.text :currency_to
      t.float :value

      t.timestamps
    end
  end
end
