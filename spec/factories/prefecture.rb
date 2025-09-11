FactoryBot.define do
  factory :prefecture do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "都道府県#{n}" }
  end
end
