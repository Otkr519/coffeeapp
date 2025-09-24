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
    @store.user = current_user
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

  if @store.user == current_user
    if @store.update(store_params)
      redirect_to @store, notice: "店舗情報を更新しました"
    else
      render :edit
    end
  else
    if @store.update(store_params_for_others)
      redirect_to @store, notice: "焙煎度・生産国を更新しました"
    else
      render :edit
    end
  end
end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
    redirect_to stores_path, notice: "店舗を削除しました"
  end

  def search
    @q = Store.ransack(params[:q])
    @stores = @q.result
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :countries, :roast_level, :image, :prefecture_id, :remove_image)
  end

  def store_params_for_others
    params.require(:store).permit(:countries, :roast_level)
  end

end
