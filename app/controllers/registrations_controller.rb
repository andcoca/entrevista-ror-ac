class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.user_type = :member

    if @user.save
      sign_in(@user)
      redirect_to books_path, notice: 'Account created successfully!'
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(update_params)
      redirect_to books_path, notice: 'Profile updated successfully!'
    else
      render :edit
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
