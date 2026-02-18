class Product < ApplicationRecord
  belongs_to :store
  has_many :line_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
