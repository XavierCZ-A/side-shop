# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :integer          not null
#
# Indexes
#
#  index_carts_on_store_id  (store_id)
#

FactoryBot.define do
  factory :cart do
    store
  end
end
