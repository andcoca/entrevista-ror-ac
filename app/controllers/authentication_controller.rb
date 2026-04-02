class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]

  # POST /auth/register
  def register
    user = User.new(user_register_params)
    user.user_type = :member

    if user.save
      serialized_user = UserSerializer.new(user)
      render json: { message: 'User registered successfully', user: serialized_user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/login
  def login
    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      sign_in(user)
      serialized_user = UserSerializer.new(user)
      render json: { message: 'Login successful', user: serialized_user }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # POST /auth/logout
  def logout
    sign_out if user_signed_in?
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def user_register_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  rescue ActionController::ParameterMissing
    params.permit(:email, :password)
  end
end
