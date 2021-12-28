class CreateMailings < ActiveRecord::Migration[6.1]
  def change
    create_table :mailings do |t|
      t.text :email
      t.text :first_name
      t.text :last_name

      t.timestamps
    end
  end
end
