FactoryGirl.define do
  factory :student do
    code '11118303'
    program
    average_grade '7.34'

    trait :code_sequence do
      sequence(:code, 11118303)
    end
  end
end
