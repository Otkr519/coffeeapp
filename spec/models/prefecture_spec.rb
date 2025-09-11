require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  describe "データの確認" do
    it "全ての都道府県データが正しく定義されていること" do
      expect(Prefecture.all.size).to eq(47)
    end

    it "特定の都道府県が存在すること" do
      prefecture = Prefecture.find_by(id: 1)
      expect(prefecture.name).to eq("北海道")
    end

    it "都道府県名がnilでないこと" do
      prefecture = Prefecture.find_by(id: 1)
      expect(prefecture.name).not_to be_nil
    end
  end

  describe "アソシエーションのテスト" do
    let(:prefecture) { Prefecture.find_by(id: 1) }
    let(:store1) { create(:store, prefecture_id: prefecture.id) }
    let(:store2) { create(:store, prefecture_id: prefecture.id) }

    it "Prefectureは多くのStoreを持つこと" do
      expect(prefecture.stores).to include(store1, store2)
    end
  end
end
