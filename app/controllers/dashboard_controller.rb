class DashboardController < ApplicationController
  def index
  end

  def quick_setup
    @company = current_user.company
    @company.update(name: params[:company_name], website_url: params[:website_url], update_preferences: params[:update_preferences])
    redirect_to dashboard_path
  end

  def quick_setup_params
    params.require(:company).permit(:name, :website_url, :update_preferences)
  end

end