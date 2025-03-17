class GeoScoringService < ApplicationService
  def initialize(keyword, company)
    @keyword = keyword
    @company = company
    @calculator = GeoScoringCalculatorService.new(@company)
  end

  def call
    analyze_providers
  end

  private

  def analyze_providers
    Rails.logger.info "Analyse des fournisseurs pour #{@keyword.name} (#{@company.name})"

    @company.ai_providers.each do |provider|
      Rails.logger.info "Analyse avec #{provider.name}"

      begin
        response = provider.analyze(@keyword.name)
        Rails.logger.info "Réponse reçue de #{provider.name}: #{response.inspect}"

        next unless response.is_a?(Array) && response.any?

        # Créer le GeoScoring avec les données initiales
        geo_scoring = GeoScoring.create!(
          keyword: @keyword,
          ai_provider: provider,
          ai_responses: response,
          url: response.first,
          created_at: Time.current
        )

        # Calculer la position et la mention
        geo_scoring.calculate_position

        # Calculer le score final
        geo_scoring.calculate_score

        Rails.logger.info "GeoScoring créé avec succès: position=#{geo_scoring.position}, mentioned=#{geo_scoring.mentioned}, score=#{geo_scoring.score}"

      rescue => e
        Rails.logger.error "Erreur lors de l'analyse avec #{provider.name}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end

  def process_provider_response(provider, response)
    @calculator.calculate_all_scores({ provider.name => response })
  end

  def calculate_global_score(scores)
    return 0 if scores.values.any?(&:nil?)

    weights = { position_score: 0.6, reference_score: 0.4 }
    weighted_sum = scores[:position_score] * weights[:position_score] +
                  scores[:reference_score] * weights[:reference_score]

    weighted_sum.round(2)
  end
end
