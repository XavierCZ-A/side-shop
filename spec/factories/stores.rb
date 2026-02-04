FactoryBot.define do
  factory :store do
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    active { false }
    primary_color { "MyString" }
    whatsapp { "MyString" }
    instagram { "MyString" }
    facebook { "MyString" }
    onboarding_complete { true }
    user
  end
end
