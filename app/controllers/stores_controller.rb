class StoresController < ApplicationController

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      redirect_to @store
    else
      render 'new'
    end
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :countries, :roast_level, :image, :introduction, :prefecture_id, :remove_image)
  end

end
