class CreatePayers < ActiveRecord::Migration[6.1]
  def change
    create_table :payers do |t|
      t.string :payer_name
      t.bigint :balance
      t.bigint :amount_spent
      t.timestamps
    end
  end
end
