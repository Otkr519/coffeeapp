FactoryBot.define do
  factory :store do
    name { "test store" }
    latitude { 35.6895 }
    longitude { 139.6917 }
    address { "Tokyo" }
    countries { "エチオピア ブラジル コロンビア インドネシア" }
    prefecture_id { Prefecture.all.sample.id }
    roast_level { "1" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/files/test.jpg'), 'image/jpeg') }

    association :user
  end
end
