class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_company_setup

  private

  def check_company_setup
    if user_signed_in? && current_user.company.nil?
      # Définir une variable pour indiquer que l'utilisateur n'a pas de company
      @needs_company_setup = true
      
      # Si ce n'est pas déjà la page d'accueil et que ce n'est pas une requête AJAX
      unless controller_name == 'welcome' || request.xhr?
        flash[:notice] = "Please set up your company before continuing."
        redirect_to root_path
      end
    end
  end
end
