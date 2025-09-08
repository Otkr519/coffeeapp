class HomeController < ApplicationController
  def index
    @stores = Store.all
    @q = Store.ransack(params[:q])
  end
end
