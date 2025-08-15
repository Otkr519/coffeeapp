class StoresController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def index
    @stores = Store.all
  end


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

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(store_params)
      redirect_to @store
    else
      render 'edit'
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    redirect_to stores_path, notice: "店舗を削除しました"
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :countries, :roast_level, :image, :prefecture_id, :remove_image)
  end

end
