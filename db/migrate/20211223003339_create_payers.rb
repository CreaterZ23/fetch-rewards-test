class CreatePayers < ActiveRecord::Migration[6.1]
  def change
    create_table :payers do |t|
      t.string :partner
      t.belongs_to :transaction
      t.timestamps
    end
  end
end
