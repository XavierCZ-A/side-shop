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
