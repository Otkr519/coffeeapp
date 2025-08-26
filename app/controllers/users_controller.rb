class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    not_match_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      sign_in :user, @user, bypass: true
      redirect_to user_path(@user), notice: '更新されました。'
    else
      render :edit
    end
  end

  def account
    @user = current_user
  end

    def guest_user
      user = User.find_or_create_by(email: 'guest@example.com') do |user|
        user.password = SecureRandom.urlsafe_base64
        user.password_confirmation = user.password
        user.name = "ゲストユーザー"
      end
      sign_in user
    end

  def favorites
    @user = current_user
    @favorite_stores = @user.liked_stores
  end

    private
  def user_params
    params.require(:user).permit(:name, :email, :introduce, :image, :favorite, :productionarea, :password, :password_confirmation)
  end

  def not_match_user
    unless @user.id == current_user.id
      redirect_to root_path , alert: '権限がありません'
    end
  end

end
