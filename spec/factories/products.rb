FactoryBot.define do
  factory :product do
    name { "MyString" }
    price { 9.99 }
    active { true }
    store
  end
end
