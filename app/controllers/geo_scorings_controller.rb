class GeoScoringsController < ApplicationController
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

  def show
    @geo_scoring = GeoScoring.find(params[:id])
  end

  private

  def geo_scoring_params
    params.require(:geo_scoring).permit(:prompt, ai_provider_ids: [])
  end

  def calculate_geoscore(ai_providers, keywords)
    ai_providers.size * 5 + keywords.size * 3
  end

  def extract_keywords_from_prompt(prompt)
    prompt_words = prompt.split(/\W+/)
    prompt_words.select { |word| Keyword.exists?(content: word) }
  end
end
