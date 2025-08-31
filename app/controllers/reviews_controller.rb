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

  private
  def set_store
    @store = Store.find(params[:store_id])
  end

  def review_params
    params.require(:review).permit(:comment, :rating)
  end

end
