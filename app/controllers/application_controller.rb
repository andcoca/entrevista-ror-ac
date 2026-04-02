class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :public_page?
  helper_method :current_user, :user_signed_in?

  protected

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_session_path, alert: 'Please log in first'
    end
  end

  def api_authenticate_user!
    unless user_signed_in?
      render json: { error: 'Authentication required' }, status: :unauthorized
    end
  end

  def user_signed_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end

  def authorize_librarian!
    render json: { error: 'Only librarians can perform this action' }, status: :forbidden unless current_user&.librarian?
  end

  private

  def public_page?
    controller_name == 'sessions' || controller_name == 'registrations'
  end
end
