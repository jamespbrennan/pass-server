class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render "new"
    end
  end

  def show
  end

  def update
    attributes = params.require(:user).permit(:email)
    current_user.update attributes

    render :show
  end

  def update_password
    attributes = params.require(:user).permit(:password, :password_confirmation)

    @current_password_error = "Current password is incorrect." unless authenticate(current_user.email, params[:user[:current_password]])
     
    current_user.update attributes

    render :show
  end

  private

  def user_params
    params.required(:user).permit(:email, :password, :password_confirmation)
  end

end
