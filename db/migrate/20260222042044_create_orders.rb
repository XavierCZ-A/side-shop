class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0
      t.decimal :total_cents, precision: 10, scale: 2
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_postal_code
      t.string :shipping_country
      t.string :payment_reference
      t.string :payment_method

      t.timestamps
    end
  end
end
