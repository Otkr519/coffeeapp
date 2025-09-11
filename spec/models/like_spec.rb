require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "バリデーションのテスト" do
    let(:user) { create(:user) }
    let(:store) { create(:store) }

    it "user_idとstore_idがあればtrueを返す" do
      like = build(:like, user: user, store: store)
      expect(like).to be_valid
    end

    it "お気に入りが重複しない" do
      create(:like, user: user, store: store)
      duplicate_like = build(:like, user: user, store: store)
      expect(duplicate_like).not_to be_valid
    end
  end

  describe "アソシエーションのテスト" do
    it "userモデルと関連付けされている" do
      should belong_to(:user)
    end

    it "storeモデルと関連付けされている" do
      should belong_to(:store)
    end
  end
end
