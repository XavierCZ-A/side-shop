# == Schema Information
#
# Table name: order_items
#
#  id               :integer          not null, primary key
#  order_id         :integer          not null
#  product_id       :integer          not null
#  quantity         :integer          not null
#  unit_price_cents :decimal(10, 2)   not null
#  product_name     :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#

FactoryBot.define do
  factory :order_item do
    order { nil }
    product { nil }
    quantity { 1 }
    unit_price_cents { "9.99" }
    product_name { "MyString" }
  end
end
