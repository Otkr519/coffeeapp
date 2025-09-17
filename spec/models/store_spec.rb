require 'rails_helper'

RSpec.describe Store, type: :model do
  let(:store) { create(:store) }

  describe "バリデーションのテスト" do

    it "有効なStoreを作成できる" do
      expect(store).to be_valid
    end

    it "名前が必須であること" do
      store.name = nil
      expect(store).not_to be_valid
    end

    it "都道府県が必須であること" do
      store.prefecture_id = nil
      expect(store).not_to be_valid
    end

    it "住所が必須であること" do
      store.address = nil
      expect(store).not_to be_valid
    end

    it "生産国が必須であること" do
      store.countries = nil
      expect(store).not_to be_valid
    end

    it "焙煎度が必須であること" do
      store.roast_level = nil
      expect(store).not_to be_valid
    end

  end

  describe "アソシエーションのテスト" do
    it "likeモデルと関連付けされている" do
      should have_many(:likes)
    end

    it "reviewモデルと関連付けされている" do
      should have_many(:reviews)
    end

    it "storeモデルがlikeモデルを経由して、userモデルと関連付けされている" do
      should have_many(:liked_users).through(:likes).source(:user)
    end

    it "prefectureアソシエーションがActiveHashと連携している" do
      association = Store.reflect_on_association(:prefecture)
      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Prefecture")
    end
  end

  describe ".ransackable_attributes" do
    it "正しい検索可能な属性を返す" do
      expect(Store.ransackable_attributes).to eq(["address", "countries", "name", "roast_level", "prefecture_id"])
    end
  end

  describe "画像アップロードのテスト" do
    it "画像がアップロードされること" do
      store.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'test/fixtures/files/test.jpg'), 'image/jpeg')
      expect(store.image).to be_present
    end
  end

  describe '画像削除機能' do
    it 'remove_image が true のとき画像が削除される' do
      expect(store.image?).to be_truthy
      store.remove_image = '1'
      store.save!
      store.reload
      expect(store.image?).to be_falsey
    end

    it 'remove_image が nil のとき画像は削除されない' do
      expect(store.image?).to be_truthy
      store.remove_image = nil
      store.save!
      store.reload
      expect(store.image?).to be_truthy
    end
  end
end
