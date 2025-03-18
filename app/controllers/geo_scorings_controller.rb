class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword, only: [:index]

  def index
    @geo_scorings_data = calculate_provider_data
    @global_score = calculate_global_score(@geo_scorings_data)
    @requests_by_date_and_ai_provider = {} 
  end

  private

  # 1️ Initialiser l'entreprise
  def set_company
    @company = Company.find_by(id: params[:company_id]) || Company.first
  end

  # 2️ Charger les mots-clés liés à l'entreprise
  def set_keywords
    @keywords = @company.keywords
  end

  # 3️ Définir le mot-clé sélectionné
  def set_selected_keyword
    @selected_keyword = @keywords.find_by(id: params[:keyword_id]) || @keywords.first
  end

  # 4️ Calcul des scores par AI Provider
  def calculate_provider_data
    return [] unless @selected_keyword

    @company.ai_providers.map do |provider|
      current_geo_scoring = GeoScoring.find_by(keyword_id: @selected_keyword.id, ai_provider_id: provider.id)

      # Calcul des scores
      position_score = current_geo_scoring&.position_score || 0
      reference_score = current_geo_scoring&.frequency_score || 0
      url_presence = current_geo_scoring&.url_presence || false

      # Calcul du score global
      score = position_score * 0.5 + reference_score * 0.3

      {
        name: provider.name,
        score: score,
        position_score: position_score,
        reference_score: reference_score,
        url_presence: url_presence
      }
    end
  end

  # 5️ Calcul du Global Score
  def calculate_global_score(providers)
    return 0 if providers.empty?

    total_score = providers.sum { |provider| provider[:score].to_f }
    (total_score / providers.size).round
  end

  helper_method :score_color_class
  def score_color_class(score)
    case score
    when 80..100 then "success"
    when 60..79 then "info"
    when 40..59 then "warning"
    else "danger"
    end
  end
end
