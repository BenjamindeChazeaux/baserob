class AiProvider < ApplicationRecord
  SERVICES = %w[openai anthropic perplexity].freeze

  has_many :requests
  has_many :company_ai_providers
  has_many :geo_scorings
  validates :name, presence: true, uniqueness: true, inclusion: { in: SERVICES }

  # Renvoie un tableau de réponses pour un mot-clé donné
  def analyze(keyword_content)
    service_class = case name
                    when 'openai'
                      Ai::Models::OpenAi
                    when 'anthropic'
                      Ai::Models::Anthropic
                    when 'perplexity'
                      Ai::Models::Perplexity
                    else
                      raise "Fournisseur d'IA non supporté: #{name}"
                    end

    # Appelle le service d'IA et récupère le résultat
    response = service_class.new(keyword_content).call

    # Traitement de la réponse
    begin
      if response.is_a?(String) && response.start_with?('[') && response.end_with?(']')
        JSON.parse(response)
      elsif response.is_a?(Array)
        response
      else
        [response.to_s]
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Erreur de parsing JSON pour #{name}: #{e.message}")
      [response.to_s]
    end
  end

  def self.find_by_referrer(referrer)
    ai_provider = AiProvider.all.find { |ai_provider| referrer.include?(ai_provider.name) }

    if ai_provider.nil?
      ai_provider = if referrer.include?('chatgpt')
        AiProvider.find_by(name: 'openai')
      elsif referrer.include?('claude')
        AiProvider.find_by(name: 'anthropic')
      end
    end

    return ai_provider
  end
end
