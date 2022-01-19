class CreateDeleteds < ActiveRecord::Migration[7.0]
  def change
    create_table :deleteds do |t|
      t.string :token
      t.string :description
      t.integer :quantity
      t.integer :price_cents

      t.timestamps
    end
  end
end
