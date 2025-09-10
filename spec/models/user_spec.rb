require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "バリデーションのテスト" do
    it "trueを返す" do
      expect(user).to be_valid
    end

    it "名前が空の場合は、無効" do
      user.name = nil
      expect(user).not_to be_valid
    end
  end

  describe "アソシエーションのテスト" do
    it "likeモデルと関連付けされている" do
      should have_many(:likes)
    end

    it "userモデルがlikeモデルを経由して、storeモデルと関連付けされている" do
      should have_many(:liked_stores).through(:likes).source(:store)
    end
  end

  describe "Deviseのテスト" do
    it "emailが必須であること" do
      should validate_presence_of(:email)
    end

    it "パスワードが必須であること" do
      should validate_presence_of(:password)
    end

    it "emailが正しいフォーマットであること" do
      should allow_value("user@example.com").for(:email)
    end

    it "emailが無効なフォーマットであるとき、拒否する" do
      should_not allow_value("userexample.com").for(:email)
    end

  end

  describe "画像アップロードのテスト" do
    it "画像がアップロードされること" do
      user.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/files/test.jpg'), 'image/jpeg')
      expect(user.image).to be_present
    end
  end
end
