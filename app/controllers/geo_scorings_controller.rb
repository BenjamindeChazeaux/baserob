class GeoScoringsController < ApplicationController
  before_action :set_keyword, only: [:history]

  # 📌 Affiche la liste des scores par AI et le score global
  def index
    @keywords = Keyword.all

    if params[:keyword_id].present?
      @selected_keyword = Keyword.find(params[:keyword_id])
      @all_scores = GeoScoring.where(keyword: @selected_keyword)
                              .includes(:ai_provider)
                              .order("geo_scorings.position_score ASC") # Trie les scores par position
    else
      @selected_keyword = nil
      @all_scores = []
    end
p
    scores = @all_scores.pluck(:position_score)
    @global_score = scores.present? ? (scores.sum.to_f / scores.size).round(2) : nil
  end

  #  Affiche l'évolution de la position d'un site en fonction d'un mot-clé
  def history
    @history_scores = GeoScoring.where(keyword: @keyword).order(created_at: :asc)

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

  def set_keyword
    @keyword = Keyword.find(params[:keyword_id])
  end
  def extract_keywords_from_prompt(prompt)
    prompt_words = prompt.split(/\W+/)
    prompt_words.select { |word| Keyword.exists?(content: word) }

end
