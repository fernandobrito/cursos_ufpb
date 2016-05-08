FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence :email do |n| "test_#{n}@example.com" end
    password 'please123'
  end
end
