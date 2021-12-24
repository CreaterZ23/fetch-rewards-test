class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.string :payer_name
      t.integer :points
      t.datetime :timestamp
      t.timestamps
    end
  end
end
