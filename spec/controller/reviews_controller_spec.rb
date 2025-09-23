require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:store) { create(:store) }

  before do
    sign_in user
  end

  describe "POST #create" do
    it "レビューを投稿できる" do
      expect {
        post :create, params: { store_id: store.id, review: { rating: 5, comment: "最高" } }
      }.to change(Review, :count).by(1)
      expect(response).to redirect_to(store_path(store))
      expect(flash[:notice]).to eq("レビューを投稿しました。")
    end
  end

  describe "PATCH #update" do
    let!(:review) { create(:review, store: store, user: user, comment: "古いコメント") }

    it "レビューを更新できる" do
      patch :update, params: { store_id: store.id, id: review.id, review: { comment: "新しいコメント" } }
      review.reload
      expect(review.comment).to eq("新しいコメント")
      expect(response).to redirect_to(store_path(store))
      expect(flash[:notice]).to eq("レビューを更新しました。")
    end
  end

  describe "DELETE #destroy" do
    let!(:review) { create(:review, store: store, user: user) }

    it "レビューを削除できる" do
      expect {
        delete :destroy, params: { store_id: store.id, id: review.id }
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to(store_path(store))
      expect(flash[:notice]).to eq("レビューを削除しました。")
    end
  end
end
