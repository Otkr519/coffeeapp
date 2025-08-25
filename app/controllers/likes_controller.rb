class LikesController < ApplicationController
  before_action :find_store

  def create
    if user_signed_in?
      @store.likes.create(user_id: current_user.id)
      redirect_to store_path(@store)
      flash[:notice] = "お気に入りしました"
    else
      flash[:alert] = "新規ユーザー登録もしくはログインが必要です"
      redirect_to new_user_session_path
    end
  end

  def destroy
    @store.likes.find_by(user_id: current_user.id).destroy
    redirect_to store_path(@store)
    flash[:notice] = "お気に入りを解除しました"
  end

  private

  def find_store
    @store = Store.find(params[:store_id])
  end
end
