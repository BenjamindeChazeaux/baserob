class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword, only: [:index]

  def index
    @providers = calculate_provider_data
    @global_score = calculate_global_score(@providers)
    @global_trend = calculate_trend(@previous_global_score, @global_score)
  end

  private

  # 1️⃣ Initialiser l'entreprise
  def set_company
    @company = Company.find_by(id: 120) || Company.first
    logger.debug "Company loaded: #{@company&.name}"
  end

  # 2️⃣ Charger les mots-clés liés à l'entreprise
  def set_keywords
    @keywords = @company.keywords
    logger.debug "Keywords loaded: #{@keywords.pluck(:content)}"
  end

  # 3️⃣ Définir le mot-clé sélectionné
  def set_selected_keyword
    @selected_keyword = @keywords.find_by(id: params[:keyword_id]) || @keywords.first
    logger.debug "Selected Keyword: #{@selected_keyword&.content}"
  end

  # 4️⃣ Calcul des scores par AI Provider avec Global Score
  def calculate_provider_data
    return [] unless @selected_keyword

    @company.ai_providers.map do |provider|
      current_geo_scoring = GeoScoring.find_by(keyword_id: @selected_keyword.id, ai_provider_id: provider.id)
      previous_geo_scoring = GeoScoring.previous_scoring(@selected_keyword.id, provider.id)

      # Calcul des scores
      global_score = current_geo_scoring&.calculate_global_score || 0

      {
        id: provider.id,
        name: provider.name,
        global_score: global_score, # ✅ Ajout du Global Score
        position_score: current_geo_scoring&.position_score || 0,
        url_score: current_geo_scoring&.calculate_url_score || 0,
        frequency_score: current_geo_scoring&.frequency_score || 0,
        trends: calculate_trends(previous_geo_scoring, current_geo_scoring)
      }
    end
  end

  # 5️⃣ Calcul du Global Score Moyenne (pour tous les providers)
  def calculate_global_score(providers)
    return 0 if providers.empty?

    total_score = providers.sum { |provider| provider[:global_score].to_f }
    (total_score / providers.size).round
  end

  # 6️⃣ Calcul des tendances pour tous les scores
  def calculate_trends(previous, current)
    return { global_score: nil, position_score: nil, url_score: nil, frequency_score: nil } unless previous && current

    {
      global_score: calculate_trend(previous.calculate_global_score, current.calculate_global_score),
      position_score: calculate_trend(previous.position_score, current.position_score),
      url_score: calculate_trend(previous.calculate_url_score, current.calculate_url_score),
      frequency_score: calculate_trend(previous.frequency_score, current.frequency_score)
    }
  end

  # 7️⃣ Calcul d'une tendance entre deux valeurs
  def calculate_trend(previous_value, current_value)
    return nil if previous_value.nil? || current_value.nil?
    return "➡️" if previous_value == current_value
    return "🔼" if current_value > previous_value
    return "🔽" if current_value < previous_value
  end
end
