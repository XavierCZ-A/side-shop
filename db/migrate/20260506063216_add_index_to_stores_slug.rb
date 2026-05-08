class AddIndexToStoresSlug < ActiveRecord::Migration[8.1]
  def change
    add_index :stores, :slug, unique: true
  end
end
