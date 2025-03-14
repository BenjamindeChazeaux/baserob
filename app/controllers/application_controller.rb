class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :check_company_setup

  private

  def check_company_setup
    @needs_company_setup = false
    if user_signed_in? && current_user.company.nil?
      @needs_company_setup = true
      
      return nil if controller_name == 'pages' && action_name == 'home' || controller_name == 'companies' && action_name == 'create'
      
      unless controller_name == 'welcome' && action_name == 'index' || request.xhr?
        flash[:notice] = "Please set up your company before continuing."
        redirect_to welcome_index_path
      end
    end
  end
end
