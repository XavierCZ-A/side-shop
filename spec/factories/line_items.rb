# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  product_id :integer          not null
#  cart_id    :integer          not null
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_line_items_on_cart_id     (cart_id)
#  index_line_items_on_product_id  (product_id)
#

FactoryBot.define do
  factory :line_item do
    product
    cart
    quantity { 1 }
  end
end
