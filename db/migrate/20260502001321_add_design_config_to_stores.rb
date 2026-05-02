class AddDesignConfigToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :design_config, :jsonb, default: {}, null: false
  end
end
