FactoryBot.define do
  factory :review do
    association :user
    association :store
    rating { rand(1..5) }
    comment { "good" }
  end
end
