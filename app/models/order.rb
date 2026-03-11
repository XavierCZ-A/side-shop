class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum status: { pending: 0, completed: 1, cancelled: 2 }
end
