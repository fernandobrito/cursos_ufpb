FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence(:email) { |n| "test_#{n}@example.com" }
    password 'please123'
  end

  factory :user_name_blank, parent: :user do
    name ''
  end

  factory :user_name_long, parent: :user do
    name 'Long Name for a Test User'
  end

  factory :user_name_with_numbers, parent: :user do
    name 'Test User 123'
  end

  factory :user_passwd_without_numbers, parent: :user do
    password 'changeme'
  end

  factory :user_passwd_without_letters, parent: :user do
    password '123456678'
  end

  factory :user_passwd_short, parent: :user do
    password 'ab12'
  end

  factory :user_passwd_long, parent: :user do
    password 'changemeplease1234'
  end
end
