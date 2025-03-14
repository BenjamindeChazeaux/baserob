class AiKeywordSearchService
  def initialize(keyword, company)
    @keyword = keyword
    @company = company
    @prompt = generate_prompt
  end

  def call
    responses = {}

    @company.ai_providers.each do |provider|
      ai_service = get_ai_service(provider.name)
      response = ai_service.call

      responses[provider.name] = response if response
    end

    create_geo_scoring(responses) if responses.any?

    responses
  end

  private

  def generate_prompt
    "List the top companies in #{@keyword.content} industry, focusing on market presence and reputation."
  end

  def get_ai_service(provider_name)
    case provider_name
    when 'openai'
      Ai::Models::OpenAi.new(@prompt)
    when 'anthropic'
      Ai::Models::Anthropic.new(@prompt)
    when 'perplexity'
      Ai::Models::Perplexity.new(@prompt)
    end
  end

  def create_geo_scoring(responses)
    calculator = GeoScoringCalculatorService.new(@company)

    responses.each do |provider_name, response|
      ai_provider = AiProvider.find_by(name: provider_name)
      scores = calculator.calculate_all_scores({ provider_name => JSON.parse(response) })

      GeoScoring.create!(
        keyword: @keyword,
        ai_provider: ai_provider,
        position_score: scores[:position_score],
        reference_score: scores[:reference_score],
        url_presence: scores[:url_presence],
        url_value: scores[:url_value],
        ai_responses: JSON.parse(response)
      )
    end
  end
end
