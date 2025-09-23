require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:store1) { create(:store) }
  let(:store2) { create(:store) }

  describe "GET #index" do
    context "リクエストが正常な場合" do
      it "正常なレスポンスを返す" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "@storesに全てのお店が格納される" do
        get :index
        expect(assigns(:stores)).to match_array([store1, store2])
      end

      it "@qにRansackオブジェクトが設定される" do
        get :index
        expect(assigns(:q)).to be_a(Ransack::Search)
      end
    end
    context "検索パラメータがある場合" do
      it "@storesが検索結果でフィルタされる" do
        store1 = create(:store, name: "Store1", countries: "エチオピア")
        store2 = create(:store, name: "Store2", countries: "ケニア")
        get :index, params: { q: { countries_eq: "エチオピア" } }
        expect(assigns(:q).result).to include(store1)
        expect(assigns(:q).result).not_to include(store2)
      end
    end
  end
end
