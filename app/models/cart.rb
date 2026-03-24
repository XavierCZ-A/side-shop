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

class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :store

  def add_product(product)
    current_item = line_items.find_or_initialize_by(product: product)
    current_item.quantity += 1 unless current_item.new_record?
    
    current_item
  end

  def total_price
    line_items.includes(:product).sum { |item| item.product.price * item.quantity }
  end
end
