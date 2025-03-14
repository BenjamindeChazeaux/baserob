class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword

  def index
    if @selected_keyword
      @geo_scorings_data = calculate_provider_data(@company, @selected_keyword)
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

  def set_company
    @company = current_user.company
  end

  def set_keywords
    @keywords = @company.keywords
  end

  def set_selected_keyword
    @selected_keyword = @keywords.find_by(id: params[:keyword_id])
  end

  def calculate_provider_data(company, keyword)
    @company.ai_providers.map do |ai_provider|
      calculate_keyword_for_ai_provider_score(keyword, ai_provider)
    end
  end

  def calculate_keyword_for_ai_provider_score(keyword, ai_provider)
    geo_scorings = GeoScoring.where(keyword: keyword, ai_provider: ai_provider)
    {
      score: geo_scorings.average(:score).to_f,
      mention_score: geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100,
      position_score: geo_scorings.average(:position).to_f,
      url_presence_score: geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100
    }
  end
end
