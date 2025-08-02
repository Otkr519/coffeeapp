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
