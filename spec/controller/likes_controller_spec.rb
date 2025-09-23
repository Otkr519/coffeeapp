require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:store) { create(:store) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "ユーザーがログインしている場合" do
      it "お気に入りを作成し、リダイレクトされる" do
        expect {
          post :create, params: { store_id: store.id }
        }.to change { store.likes.count }.by(1)

        expect(response).to redirect_to(store_path(store))
        expect(flash[:notice]).to eq("お気に入りしました")
      end
    end

    context "ユーザーがログインしていない場合" do
      before { sign_out user }

      it "新規ユーザー登録ページにリダイレクトされる" do
        post :create, params: { store_id: store.id }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("新規ユーザー登録もしくはログインが必要です")
      end
    end
  end

  describe "DELETE #destroy" do
    context "ユーザーがログインしている場合" do
      before do
        store.likes.create(user_id: user.id)
      end

      it "お気に入りを解除し、リダイレクトされる" do
        expect {
          delete :destroy, params: { store_id: store.id }
        }.to change { store.likes.count }.by(-1)

        expect(response).to redirect_to(store_path(store))
        expect(flash[:notice]).to eq("お気に入りを解除しました")
      end
    end
  end
end
