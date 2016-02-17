FactoryGirl.define do
  factory :post do
    title { Faker::Lorem::sentence }
    body { Faker::Lorem.paragraphs(2) }
    association(:created_by, factory: :user)

    factory :post_with_categories do
      after(:create) do |post|
        create_list(:category, 3, created_by: post.created_by, posts: [post])
      end
    end
  end
end
