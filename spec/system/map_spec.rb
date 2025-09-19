require 'rails_helper'

RSpec.describe "Map", type: :system do

  before do
    @store = create(:store)
  end

  describe 'トップページでのマップ表示確認' do
  it "地図が表示される。店舗情報をクリックすると詳細が表示される" do
    visit root_path
    expect(page).to have_selector('#map')
  end

  it "店舗情報をクリックすると詳細が表示される" do
    visit root_path
    execute_script("google.maps.event.trigger(window.markers[0], 'click');")
    expect(page).to have_content(@store.name)
    expect(page).to have_content(@store.address)
    expect(page).to have_content(@store.countries)
    expect(page).to have_css("img[src*='#{@store.image.url }']")
  end
end

  describe '店舗詳細ページでのマップ表示確認' do
    it "店舗の詳細ページで地図が表示される。マーカーが正しく表示される" do
      visit store_path(@store)
      expect(page).to have_selector('#map')
    end

    it "店舗の詳細ページで地図が表示される。マーカーが正しく表示される" do
      visit store_path(@store)
      execute_script("google.maps.event.trigger(window.markers[0], 'click');")
      expect(page).to have_content(@store.name)
    end
  end
end
