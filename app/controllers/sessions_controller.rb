class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  skip_before_action :authenticate_user!

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      sign_in(user)
      redirect_to books_path, notice: 'Logged in successfully!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to new_session_path, notice: 'Logged out successfully!'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
