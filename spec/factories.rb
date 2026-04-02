FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    user_type { :member }
  end

  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    sequence(:isbn) { |n| "ISBN#{n}ABC" }
    total_copies { 5 }
    available_copies { 5 }
  end

  factory :borrow do
    user { create(:user) }
    book { create(:book) }
    borrowed_at { Time.current }
    due_at { 2.weeks.from_now }
    returned_at { nil }
  end

  factory :profile do
    user { create(:user) }
    bio { Faker::Lorem.paragraph }
  end
end
