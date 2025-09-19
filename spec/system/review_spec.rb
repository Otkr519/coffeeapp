require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  let!(:user) { create(:user) }
  let!(:store) { create(:store) }
  let!(:review) { create(:review, store: store, user: user, comment: "良いお店でした！", rating: 4) }

  before do
    sign_in user
  end

  it "レビューを投稿できる" do
    visit store_path(store)

    click_link "レビューを投稿する"

    select "★★★★☆ (4)", from: "評価"
    fill_in "コメント", with: "良いお店でした！"
    click_button "投稿する"

    expect(page).to have_content("良いお店でした！")
    expect(page).to have_content("★ ★ ★ ★ ☆")
  end

  it "レビューを編集できる" do
    visit edit_store_review_path(store, review)

    fill_in "コメント", with: "とても良いお店でした！"
    select "5", from: "評価"
    click_button "投稿する"

    expect(page).to have_content("とても良いお店でした！")
    expect(page).to have_content("★ ★ ★ ★ ★")
  end

  describe "レビュー削除" do
    it "レビューを削除できる" do
      visit store_path(store)
      click_link "レビュー削除"

      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_content("良いお店でした！")
      expect(page).to have_content("まだレビューがありません。")
    end
  end

end
