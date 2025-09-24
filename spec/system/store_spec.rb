require 'rails_helper'

RSpec.describe "Stores", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store, user: user) }
  let(:other_user) { create(:user) }

  describe "店舗登録" do
    it "正常に登録できること" do
      sign_in user
      visit new_store_path

      fill_in "store[name]", with: "テスト珈琲店"
      select "東京都", from: "store[prefecture_id]"
      fill_in "store[address]", with: "渋谷区1-1-1"
      fill_in "store[countries]", with: "エチオピア"
      select "3 中煎り", from: "store[roast_level]"

      click_button "登録"

      expect(page).to have_content "テスト珈琲店"
      expect(page).to have_content "東京都"
      expect(page).to have_content "渋谷区1-1-1"
      expect(page).to have_content "エチオピア"
      expect(page).to have_selector(".coffeebeans_icon", count: 3)
    end

    it "エラーメッセージが表示されること" do
      sign_in user
      visit new_store_path

      fill_in "store[name]", with: ""
      select "都道府県を選択してください", from: "store[prefecture_id]"
      fill_in "store[address]", with: ""
      fill_in "store[countries]", with: ""
      select "焙煎度を選択してください。", from: "store[roast_level]"

      click_button "登録"

      expect(page).to have_content "店舗名を入力してください"
      expect(page).to have_content "都道府県を入力してください"
      expect(page).to have_content "住所を入力してください"
      expect(page).to have_content "生産国を入力してください"
      expect(page).to have_content "焙煎度を入力してください"
    end
  end

  describe "店舗編集" do
    context "登録者本人の場合" do

      it "全項目を編集できる" do
        sign_in user
        visit edit_store_path(store)

        fill_in "store[name]", with: "編集後珈琲"
        select "神奈川県", from: "store[prefecture_id]"
        fill_in "store[address]", with: "横浜1-1-1"
        fill_in "store[countries]", with: "ケニア"
        select "3 中煎り", from: "store[roast_level]"
        click_button "登録"

        expect(page).to have_content("編集後珈琲")
        expect(page).to have_content("ケニア")
        expect(page).to have_selector(".coffeebeans_icon", count: 3)
      end
    end

    context "他ユーザーの場合" do
      it "編集できる項目は焙煎度と生産国のみ" do
        sign_in other_user
        visit edit_store_path(store)

        expect(page).not_to have_field("店舗名")
        expect(page).not_to have_field("住所")

        fill_in "store[countries]", with: "コロンビア"
        select "2 中浅煎り", from: "store[roast_level]"
        click_button "登録"

        expect(page).to have_content("コロンビア")
        expect(page).to have_selector(".coffeebeans_icon", count: 2)
      end
    end
  end

  describe "店舗削除" do
    let!(:store) { create(:store, user: user, name: "削除テスト店") }

    context "登録者本人の場合" do

      it "削除できること" do
        sign_in user
        visit store_path(store)

        accept_confirm do
          click_link "店舗を削除"
        end

        expect(page).to have_content "店舗を削除しました"
        expect(page).not_to have_content "削除テスト店"
      end
    end

    context "他ユーザーの場合" do

      it "削除ボタンが表示されないこと" do
        sign_in other_user
        visit store_path(store)
        expect(page).not_to have_link "店舗を削除"
      end
    end

    context "未ログインの場合" do
      it "削除ボタンが表示されないこと" do
        visit store_path(store)
        expect(page).not_to have_link "店舗を削除"
      end
    end
  end
end
