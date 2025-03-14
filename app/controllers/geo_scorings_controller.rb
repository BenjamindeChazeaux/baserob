class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword

  # 📌 Affiche la liste des scores par AI et le score global
  def index
    if @selected_keyword
      @calculator = GeoScoringCalculatorService.new(@company)
      @provider_data = calculate_provider_data
      @global_score = calculate_global_score
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def search
    keyword_content = params[:keyword_content]
    keyword = Keyword.find_or_create_by!(content: keyword_content, company: @company)

    service = AiKeywordSearchService.new(keyword, @company)
    service.call

    redirect_to geo_scorings_path(keyword_id: keyword.id), notice: "Analyse terminée pour le mot-clé '#{keyword_content}'"
  rescue StandardError => e
    redirect_to geo_scorings_path, alert: "Erreur lors de l'analyse : #{e.message}"
  end

  #  Affiche l'évolution de la position d'un site en fonction d'un mot-clé
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

  def create
    @geo_scoring = GeoScoring.new(geo_scoring_params)
    @geo_scoring.ai_providers = AiProvider.find(params[:geo_scoring][:ai_provider_ids]) if params[:geo_scoring][:ai_provider_ids]
    extracted_keywords = extract_keywords_from_prompt(params[:geo_scoring][:prompt])
    @geo_scoring.keywords = Keyword.where(content: extracted_keywords)
    @geo_scoring.score = calculate_geoscore(@geo_scoring.ai_providers, @geo_scoring.keywords)

    if @geo_scoring.save
      redirect_to @geo_scoring
    else
      render :new
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def set_keywords
    @keywords = @company.keywords
  end

  def set_selected_keyword
    @selected_keyword = if params[:keyword_id].present?
      @keywords.find_by(id: params[:keyword_id])
    else
      @keywords.last
    end
  end

  def calculate_provider_data
    @company.company_ai_providers.map do |company_ai_provider|
      ai_provider = company_ai_provider.ai_provider
      current_scoring = fetch_current_scoring(ai_provider)
      previous_scoring = fetch_previous_scoring(ai_provider)
      position_change = calculate_position_change(current_scoring, previous_scoring)

      {
        name: ai_provider.name,
        position_change: position_change,
        responses: current_scoring&.ai_responses || [],
        position_score: current_scoring&.position_score || 0,
        reference_score: current_scoring&.reference_score || 0,
        url_presence: current_scoring&.url_presence || false,
        url_value: current_scoring&.url_value || nil,
        global_score: calculate_provider_global_score(current_scoring)
      }
    end
  end

  def fetch_current_scoring(ai_provider)
    @selected_keyword.geo_scorings
                    .where(ai_provider: ai_provider)
                    .order(created_at: :desc)
                    .first
  end

  def fetch_previous_scoring(ai_provider)
    @selected_keyword.geo_scorings
                    .where(ai_provider: ai_provider)
                    .where('created_at < ?', Time.current)
                    .order(created_at: :desc)
                    .first
  end

  def calculate_position_change(current, previous)
    return 0 unless current && previous
    previous.position_score - current.position_score
  end

  def calculate_provider_global_score(scoring)
    return 0 unless scoring

    position_weight = 0.4
    frequency_weight = 0.3
    url_weight = 0.3

    position_score = scoring.position_score || 0
    frequency_score = scoring.reference_score || 0
    url_score = scoring.url_presence ? 100 : 0

    (position_score * position_weight) +
    (frequency_score * frequency_weight) +
    (url_score * url_weight)
  end

  def calculate_global_score
    return 0 if @provider_data.empty?

    total_score = @provider_data.sum { |data| data[:global_score] }
    total_score / @provider_data.length
  end

  def extract_keywords_from_prompt(prompt)
    prompt_words = prompt.split(/\W+/)
    prompt_words.select { |word| Keyword.exists?(content: word) }
  end
end
