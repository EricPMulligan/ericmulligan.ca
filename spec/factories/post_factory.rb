FactoryGirl.define do
  factory :post do
    title { Faker::Lorem::sentence }
    body { Faker::Lorem.paragraphs(2) }
    association(:created_by, factory: :user)
  end
end
