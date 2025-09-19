require 'rails_helper'

RSpec.describe 'Search', type: :system do
  before do
    @store = create(:store)
    @user = create(:user)
    sign_in @user
  end

  describe 'トップページでの検索動作確認' do
    it '検索フォームが表示され、検索できる' do
      visit root_path
      expect(page).to have_field('店舗名で検索')
      fill_in '店舗名で検索', with: 'test store'
      click_button '検索'
      expect(page).to have_content('test store')
    end

    it '検索結果が正しく表示される' do
      visit root_path
      fill_in '店舗名で検索', with: 'test store'
      click_button '検索'
      expect(page).to have_content('test store')
    end

    it '人気な生産国のカードで、検索できる' do
      visit root_path
      expect(page).to have_link('エチオピア')
      expect(page).to have_link('ブラジル')
      expect(page).to have_link('コロンビア')
      expect(page).to have_link('インドネシア')

      click_link 'エチオピア'
      expect(page).to have_current_path(search_stores_path(q: { countries_cont: "エチオピア" }))

      visit root_path
      click_link 'ブラジル'
      expect(page).to have_current_path(search_stores_path(q: { countries_cont: "ブラジル" }))

      visit root_path
      click_link 'コロンビア'
      expect(page).to have_current_path(search_stores_path(q: { countries_cont: "コロンビア" }))

      visit root_path
      click_link 'インドネシア'
      expect(page).to have_current_path(search_stores_path(q: { countries_cont: "インドネシア" }))
    end
  end

  describe '検索ページでの検索動作確認' do
    it '検索フォームが表示され、検索できる' do
      visit search_stores_path
      expect(page).to have_field('店舗名')
      fill_in '店舗名', with: 'test store'
      click_button '検索'
      expect(page).to have_content('test store')
    end

    it '地域の選択肢が表示される' do
      visit search_stores_path
      expected_options = ['未選択'] + Prefecture.pluck(:name)
      expect(page).to have_select('地域', options: expected_options)
    end

    it '生産国の入力フィールドが表示される' do
      visit search_stores_path
      expect(page).to have_field('生産国')
      fill_in '生産国', with: 'エチオピア'
      click_button '検索'
      expect(page).to have_content('エチオピア')
    end

    it '焙煎度の選択肢が表示される' do
      visit search_stores_path
      expect(page).to have_select('焙煎度', options: ['未選択', '浅煎り', '中浅煎り', '中煎り', '中深煎り', '深煎り'])
    end

    it '検索結果が表示される' do
      visit search_stores_path
      fill_in '店舗名', with: 'test store'
      click_button '検索'
      expect(page).to have_content('検索結果')
      expect(page).to have_content('test store')
    end

  it '店舗情報がリストとして表示される' do
      visit search_stores_path
      expect(page).to have_css('.store_list')
      within '.store_item' do
        expect(page).to have_content('test store')
        expect(page).to have_content('Tokyo')
        expect(page).to have_content('エチオピア')
      end
    end
  end
end
