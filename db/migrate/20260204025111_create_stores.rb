class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.boolean :active, default: true, null: false
      t.string :primary_color
      t.string :whatsapp
      t.string :instagram
      t.string :facebook

      t.timestamps
    end
  end
end
