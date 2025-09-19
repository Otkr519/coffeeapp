require 'rails_helper'

RSpec.describe Review, type: :model do

  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:review) { build(:review, user: user, store: store) }

  it "有効なレビューを作成できること" do
    expect(review).to be_valid
  end

  it "userが必須であること" do
    review.user = nil
    expect(review).not_to be_valid
  end

  it "storeが必須であること" do
    review.store = nil
    expect(review).not_to be_valid
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
