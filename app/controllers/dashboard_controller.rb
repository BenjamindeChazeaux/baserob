class DashboardController < ApplicationController
  # Affiche le tableau de bord principal
  def index
    @requests = Request.all
    @geo_scorings = GeoScoring.all
    @competitors = Competitor.all
    @keywords = Keyword.all
    @company_ai_providers = CompanyAiProvider.all
    @ai_providers = AiProvider.all
  end

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.new(dashboard_params)
    if @dashboard.save
      redirect_to dashboards_path, notice: "Dashboard was successfully created."
    else
      render :new
    end
  end

  # Traite la soumission du formulaire QuickStart
  def quick_setup
    # Extraire les paramètres du formulaire
    company_name = params[:dashboard][:company_name]
    website_url = params[:dashboard][:website_url]
    
    # Créer une nouvelle company
    @company = Company.new(
      name: company_name,
      domain: website_url
    )
    
    if @company.save
      # Associer l'utilisateur actuel à la company
      current_user.update(company: @company)
      
      # Répondre en JSON pour la modal
      render json: { 
        success: true, 
        message: "Your company has been set up successfully!" 
      }
    else
      # En cas d'erreur
      render json: { 
        success: false, 
        message: @company.errors.full_messages.join(", ") 
      }
    end
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:name, :description)
  end
end