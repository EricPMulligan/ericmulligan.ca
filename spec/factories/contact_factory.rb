FactoryGirl.define do
  factory(:contact) do
    name { Faker::Internet.name }
    email { Faker::Internet.email }
    body { Faker::Lorem.paragraph }

    factory(:read_contact) do
      read_at { DateTime.now }
      association(:read_by, factory: :user)
    end
  end
end
