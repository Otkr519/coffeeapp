require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET #show" do
    it "正常なレスポンスを返す" do
      sign_in user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    context "自分の編集ページの場合" do
      it "正常なレスポンスを返す" do
        sign_in user
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "他のユーザーの編集ページの場合" do
      it "ホームにリダイレクトされる" do
        sign_in other_user
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('権限がありません')
      end
    end
  end

  describe "PATCH #update" do
    context "自分の情報を変更する場合" do
      it "変更に成功し、詳細ページにリダイレクトされる" do
        sign_in user
        patch :update, params: { id: user.id, user: { name: "update name" } }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq('更新されました。')
        expect(user.reload.name).to eq("update name")
      end
    end

    context "無効な情報を送信した場合" do
      it "ユーザー情報が更新されず、編集ページに戻る" do
        sign_in user
        patch :update, params: { id: user.id, user: { name: "" } }
        expect(response).to render_template(:edit)
        expect(user.reload.name).not_to eq("")
      end
    end
  end

  describe "GET #account" do
    it "正常なレスポンスを返す" do
      sign_in user
      get :account
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #favorites" do
    context "正常なリクエストの場合" do
      it "正常なレスポンスを返す" do
        sign_in user
        get :favorites, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it "@favorite_stores に正しいデータが格納される" do
        store = create(:store)
        sign_in user
        user.liked_stores << store
        get :favorites, params: { id: user.id }
        expect(assigns(:favorite_stores)).to include(store)
      end
    end
  end
end
