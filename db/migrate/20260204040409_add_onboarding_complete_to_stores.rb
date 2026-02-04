class AddOnboardingCompleteToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :onboarding_complete, :boolean, default: false, null: false
  end
end
