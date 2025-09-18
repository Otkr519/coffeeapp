require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:guest_user) { create(:user, email: 'guest@example.com') }

  describe "ユーザー登録" do
    it "ユーザーが正常に登録できること" do
      visit new_user_registration_path
      fill_in "アカウント名", with: "New User"
      fill_in "メールアドレス", with: "newuser@example.com"
      fill_in "パスワード", with: "password"
      click_button "新規アカウントを作成"
      expect(page).to have_content("アカウント登録が完了しました。")
      expect(User.last.name).to eq("New User")
    end

    it "エラーメッセージが表示されること" do
      visit new_user_registration_path
      fill_in "アカウント名", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "新規アカウントを作成"
      expect(page).to have_content("アカウント名を入力してください")
      expect(page).to have_content("メールアドレスを入力してください")
      expect(page).to have_content("パスワードを入力してください")
    end
  end

  describe "ログイン" do
    it "ログイン後、ユーザーがホームにリダイレクトされること" do
      sign_in user
      visit root_path
      expect(page).to have_current_path(root_path)
    end

    it "エラーメッセージが表示されること" do
      visit new_user_session_path
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "ログインする"
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    end

    it "ゲストログインボタンをクリックすると、ゲストログインできること" do
      visit new_user_session_path
      click_button "ゲストログイン"
      visit root_path
      expect(page).to have_current_path(root_path)
    end
  end

  it "アカウント新規登録ボタンをクリックすると、遷移すること" do
    visit new_user_session_path
    click_link "アカウント新規登録"
    expect(page).to have_current_path(new_user_registration_path)
  end

  describe "ユーザー情報の編集" do
    it "ユーザーがプロフィールを編集できること" do
      sign_in user
      visit edit_user_registration_path
      fill_in "メールアドレス", with: "test_edit@example"
      fill_in "new_pass", with: "newpassword"
      fill_in "password_confirmation", with: "newpassword"
      click_button "更新"
      expect(page).to have_content("更新されました。")
      expect(user.reload.email).to eq("test_edit@example")
    end
  end

  describe "ゲストユーザーの制限" do
    it "ゲストユーザーはユーザー設定を変更できないこと" do
      sign_in guest_user
      visit edit_user_registration_path
      expect(page).to have_content("ゲストユーザーはユーザー設定を変更できません。")
      expect(page).to have_field("メールアドレス", disabled: true)
      expect(page).to have_field("new_pass", disabled: true)
      expect(page).to have_field("password_confirmation", disabled: true)
      expect(page).to have_button("更新", disabled: true)
    end
  end

  describe "パスワード表示機能" do
    it "パスワード表示/非表示が機能すること" do
      sign_in user
      visit edit_user_registration_path
      check "show_passwords"
      expect(find("#new_pass")[:type]).to eq("text")
      expect(find("#password_confirmation")[:type]).to eq("text")
      uncheck "show_passwords"
      expect(find("#new_pass")[:type]).to eq("password")
      expect(find("#password_confirmation")[:type]).to eq("password")
    end
  end

  describe "キャンセルリンク" do
    it "キャンセルリンクが正しく動作すること" do
      sign_in user
      visit edit_user_registration_path
      click_link "キャンセル"
      expect(page).to have_current_path('/account')
    end
  end
end
