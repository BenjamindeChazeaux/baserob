class DashboardController < ApplicationController
  # Affiche le tableau de bord principal
  def index
    # Récupérer les données nécessaires pour le tableau de bord
    @company = current_user.company if current_user
  end

  # Traite la soumission du formulaire QuickStart
  def quick_setup
    # Récupérer l'entreprise de l'utilisateur actuel
    @company = current_user.company
    
    # Mettre à jour les attributs de l'entreprise avec les données du formulaire
    if @company.update(quick_setup_params)
      # Répondre avec un JSON en cas de succès
      render json: { success: true, message: 'Configuration saved successfully' }
    else
      # Répondre avec un JSON en cas d'erreur
      render json: { success: false, message: @company.errors.full_messages.join(', ') }
    end
  end

  private

  # Paramètres autorisés pour la mise à jour rapide
  def quick_setup_params
    params.require(:dashboard).permit(:company_name, :website_url, :update_preferences)
  end
end