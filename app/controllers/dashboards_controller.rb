class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  # GET /dashboard or /dashboards/show
  def show
    if current_user.librarian?
      redirect_to librarian_dashboard_path
    else
      redirect_to member_dashboard_path
    end
  end

  # GET /dashboards/librarian
  def librarian
    authorize_librarian!
    render :librarian
  end

  # GET /dashboards/member
  def member
    render :member
  end
end
