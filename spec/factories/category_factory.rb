FactoryGirl.define do
  factory(:category) do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association(:created_by, factory: :user)
  end
end
