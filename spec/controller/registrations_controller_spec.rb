require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:guest_user) { create(:user, email: "guest@example.com") }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "DELETE #destroy" do
    context "通常ユーザー" do
      before { sign_in user }

      it "アカウントが削除される" do
        expect {
          delete :destroy
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "ゲストユーザー" do
      before { sign_in guest_user }

      it "削除されずリダイレクトされる" do
        expect {
          delete :destroy
        }.not_to change(User, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "ゲストユーザーは退会できません。"
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        delete :destroy
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
