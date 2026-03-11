FactoryBot.define do
  factory :order do
    status { 1 }
    total_cents { "9.99" }
    shipping_address { "MyString" }
    shipping_city { "MyString" }
    shipping_postal_code { "MyString" }
    shipping_country { "MyString" }
    payment_reference { "MyString" }
    payment_method { "MyString" }
  end
end
