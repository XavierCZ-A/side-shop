# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  active      :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  store_id    :integer          not null
#  description :text
#
# Indexes
#
#  index_products_on_store_id  (store_id)
#

FactoryBot.define do
  factory :product do
    name { "MyString" }
    price { 9.99 }
    active { true }
    store
    trait :with_images do
      after(:build) do |product|
        product.images.attach(
          io: StringIO.new("fake image content"),
          filename: 'product_image.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
