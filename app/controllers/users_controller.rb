class UsersController < ApplicationController
  def new
    # eroorが発生した際、以前追記したformの内容を残す。 => flash[:user]
    @user = User.new(flash[:user])
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to mypage_path
    else
      redirect_to :back, flash: {
        user: user,
        error_messages: user.errors.full_messages
      }
    end
  end

  def me
  end

  private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
