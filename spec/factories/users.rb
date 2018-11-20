FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    email
    password "password"
    password_confirmation "password"
    confirmed_at 2.hours.ago
  end
end
