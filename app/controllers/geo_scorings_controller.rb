class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword, only: [:index]

  def index
    if @selected_keyword
      @geo_scorings_data = calculate_provider_data #(@company, @selected_keyword)
    end


  end

  def history
    @history_scores = GeoScoring.where(keyword: @selected_keyword).order(created_at: :asc)

    respond_to do |format|
      format.html { render partial: "history", locals: { history_scores: @history_scores } }
      format.json { render json: @history_scores }
    end
  end

  def new
    @geo_scoring = GeoScoring.new
    @ai_providers = AiProvider.all
    @keywords = Keyword.all
  end

  private

  # 1️⃣ Initialiser l'entreprise
  def set_company
    @company = Company.find_by(id: params[:company_id]) || Company.first
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

  # 4️⃣ Calcul des scores par AI Provider
<<<<<<< HEAD
  def calculate_provider_data
    @company.ai_providers.map do |ai_provider|
      calculate_keyword_for_ai_provider_score(@selected_keyword, ai_provider)
=======
  def calculate_provider_data(company, keyword)
    @company.ai_providers.map do |ai_provider|
      calculate_keyword_for_ai_provider_score(keyword, ai_provider)
>>>>>>> master
    end
  end

  def calculate_keyword_for_ai_provider_score(keyword, ai_provider)
    geo_scorings = GeoScoring.where(keyword: keyword, ai_provider: ai_provider)
    {
      name: ai_provider.name,
      score: geo_scorings.average(:score).to_f,
      mention_score: geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100,
      position_score: geo_scorings.average(:position).to_f,
      url_presence_score: geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100
    }
  end

  # 5️⃣ Calcul du Global Score
  def calculate_global_score(providers)
    return 0 if providers.empty?

    total_score = providers.sum { |provider| provider[:score].to_f }
    (total_score / providers.size).round
  end

  # Helper pour déterminer la classe de couleur du score
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
