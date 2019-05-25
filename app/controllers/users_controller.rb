class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[me]

  def new
    @user = User.new(flash[:user])
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to mypage_path
    else
      flash[:user] = user
      flash[:error_messages] = user.errors.full_messages
      redirect_back fallback_location: new_user_path
    end
  end

  def me
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless @current_user
        flash[:notice ] = "ログインしてください"
      redirect_to root_path
    end
  end
end
