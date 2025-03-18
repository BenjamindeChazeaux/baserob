class GeoScoringService < ApplicationService
  def initialize(keyword, company)
    @keyword = keyword
    @company = company
  end

  def call
    analyze_providers
  end

  private

  def analyze_providers
    Rails.logger.info "Analyse des fournisseurs pour #{@keyword.content} (#{@company.name})"

    @company.ai_providers.each do |provider|
      Rails.logger.info "Analyse avec #{provider.name}"

      begin
        # Récupération des réponses de l'IA
        response = provider.analyze(@keyword.content)
        Rails.logger.info "Réponse reçue de #{provider.name}: #{response.inspect}"

        next unless response.is_a?(Array) && response.any?

        # Créer ou mettre à jour le GeoScoring
        geo_scoring = GeoScoring.find_or_initialize_by(
          keyword: @keyword,
          ai_provider: provider,
          created_at: Time.current.beginning_of_day..Time.current.end_of_day
        )

        # Mise à jour des données
        geo_scoring.ai_responses = response
        geo_scoring.url = response.first if response.first.present?

        # Les méthodes calculate_position et calculate_score sont appelées automatiquement
        # grâce aux callbacks before_save
        if geo_scoring.save
          Rails.logger.info "GeoScoring créé/mis à jour avec succès: position=#{geo_scoring.position}, mentioned=#{geo_scoring.mentioned}, score=#{geo_scoring.score}"
        else
          Rails.logger.error "Erreur lors de la sauvegarde du GeoScoring: #{geo_scoring.errors.full_messages.join(', ')}"
        end

      rescue => e
        Rails.logger.error "Erreur lors de l'analyse avec #{provider.name}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
