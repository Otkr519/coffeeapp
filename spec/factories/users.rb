FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    image { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/test.jpg'), 'image/jpeg') }
  end
end
