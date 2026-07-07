class AddStripeAccountIdToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :stripe_account_id, :string
  end
end
