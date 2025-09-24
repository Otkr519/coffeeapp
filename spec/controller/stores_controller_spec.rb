require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  let!(:user) { create(:user) }
  let!(:store) { create(:store, user: user) }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "正常なレスポンスを返す" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "@storesにデータが格納される" do
      get :index
      expect(assigns(:stores)).to include(store)
    end
  end

  describe "GET #show" do
    it "正常なレスポンスを返す" do
      get :show, params: { id: store.id }
      expect(response).to have_http_status(:success)
    end

    it "@storeに正しいデータが格納される" do
      get :show, params: { id: store.id }
      expect(assigns(:store)).to eq(store)
    end
  end

  describe "POST #create" do
    it "新しい店舗を作成する" do
      expect {
        post :create, params: { store: { name: "test store", address: "東京", prefecture_id: 1, countries: "ブラジル", roast_level: 1} }
      }.to change(Store, :count).by(1)
      expect(response).to redirect_to(store_path(assigns(:store)))
    end

    it "無効な店舗が作成されない" do
      expect {
        post :create, params: { store: { name: "", address: "", prefecture_id: 1, countries: "", roast_level: ""} }
      }.not_to change(Store, :count)
      expect(response).to render_template(:new)
    end
  end

describe "PATCH #update" do
  context "登録者本人の場合" do
    it "全項目を更新できる" do
      patch :update, params: { id: store.id, store: { name: "update store", address: "神奈川", prefecture_id: 2, countries: "エチオピア", roast_level: 2} }
      store.reload
      expect(store.name).to eq("update store")
      expect(store.address).to eq("神奈川")
      expect(store.prefecture_id).to eq(2)
      expect(store.countries).to eq("エチオピア")
      expect(store.roast_level).to eq(2)
      expect(response).to redirect_to(store_path(store))
      expect(flash[:notice]).to eq("店舗情報を更新しました")
    end

  it "無効な情報だと更新できない" do
      patch :update, params: { id: store.id, store: { name: "" } }
      expect(response).to render_template(:edit)
    end
  end

  context "登録者以外のユーザーの場合" do
    let!(:other_user) { create(:user) }

    before do
      sign_in other_user
    end

    it "焙煎度・生産国だけ更新できる" do
      patch :update, params: { id: store.id, store: { roast_level: 4, countries: "ブラジル" } }
      store.reload
      expect(store.roast_level).to eq(4)
      expect(store.countries).to eq("ブラジル")
      expect(response).to redirect_to(store_path(store))
      expect(flash[:notice]).to eq("焙煎度・生産国を更新しました")
    end

    it "他の項目は更新できない" do
      other_name = store.name
      patch :update, params: { id: store.id, store: { name: "変更" } }
      store.reload
      expect(store.name).to eq(other_name)
    end
  end
end

  describe "DELETE #destroy" do
    it "店舗を削除する" do
      expect {
        delete :destroy, params: { id: store.id }
      }.to change(Store, :count).by(-1)

      expect(response).to redirect_to(stores_path)
      expect(flash[:notice]).to eq("店舗を削除しました")
    end

  end

  describe "GET #search" do
    it "検索結果が正しく返される" do
      get :search, params: { q: { name_cont: "test store" } }
      expect(assigns(:stores)).to include(store)
    end
  end
end
