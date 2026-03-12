class Store < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :carts, dependent: :destroy
end
