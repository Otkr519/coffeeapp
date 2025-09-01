class ReviewsController < ApplicationController
  before_action :set_store
  def new
    @review = @store.reviews.build
  end

  def create
    @review = @store.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @store, notice: 'レビューを投稿しました。'
    else
      render 'new'
    end
  end

  def edit
    @review = @store.reviews.find(params[:id])
    not_match_user
  end

  def update
    @review = @store.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to @store, notice: 'レビューを更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @review = @store.reviews.find(params[:id])
    @review.destroy
    redirect_to @store, notice: 'レビューを削除しました。'
  end


private
  def set_store
    @store = Store.find(params[:store_id])
  end

  def review_params
    params.require(:review).permit(:comment, :rating)
  end

  def not_match_user
    unless @review.user == current_user
      redirect_to @store, alert: '権限がありません。'
    end
  end

end
