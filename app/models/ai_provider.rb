class AiProvider < ApplicationRecord
  SERVICES = %w[openai anthropic perplexity].freeze

  has_many :requests
  has_many :company_ai_providers
  has_many :geo_scorings
  validates :name, presence: true, uniqueness: true, inclusion: { in: SERVICES }

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
