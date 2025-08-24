class HomeController < ApplicationController
  def index
    @q = Store.ransack(params[:q])
  end
end
