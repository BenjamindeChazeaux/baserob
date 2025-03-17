class AiKeywordSearchService < ApplicationService
  def initialize(keyword, company)
    @keyword = keyword
    @company = company
  end

  def call
    analyze_providers
  end

  private

  def analyze_providers
    results = []
    failed_providers = []

    @company.ai_providers.each do |provider|
      begin
        Rails.logger.info("Démarrage de l'analyse pour #{provider.name}")
        response = send_request(provider)

        if response
          normalized_response = normalize_response(response)
          results << {
            name: provider.name,
            response: normalized_response
          }
          Rails.logger.info("Analyse réussie pour #{provider.name}")
        else
          failed_providers << provider.name
          Rails.logger.warn("Aucun résultat pour #{provider.name}")
        end
      rescue StandardError => e
        failed_providers << provider.name
        Rails.logger.error("Échec pour #{provider.name}: #{e.message}\n#{e.backtrace.join("\n")}")
      end
    end

    if results.empty?
      error_message = "Aucun résultat d'analyse n'a été obtenu"
      error_message += ". Providers en échec: #{failed_providers.join(', ')}" if failed_providers.any?
      raise StandardError, error_message
    end

    results
  end

  def send_request(provider)
    service = provider.service_class.new(@keyword, @company)
    service.call
  end

  def normalize_response(response)
    return [] unless response.is_a?(Array)

    response.map do |item|
      # Supprimer les caractères spéciaux et extra-espaces
      item.to_s.gsub(/[^\w\s-]/, ' ').squeeze(' ').strip
    end.reject(&:empty?).uniq
  end
end
