class AddIndustryToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :industry, :string
  end
end
