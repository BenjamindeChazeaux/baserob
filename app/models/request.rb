class Request < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider, optional: true

  validates :company, presence: true
  validates :ai_provider, presence: true
  validates :user_agent, presence: true
  validates :referrer, presence: true
  validates :domain, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp}
  validates :path, presence: true

  before_validation :set_ai_provider

  private

  def set_ai_provider
    ai_provider = {
      'http://ww.mistral.ai': AiProvider.find_by(name: 'Mistral'),
      'http://ww.openai.ai': AiProvider.find_by(name: 'ChatGPT'),
      'http://claude.io': AiProvider.find_by(name: 'Claude')
    }[self.referrer]

    self.ai_provider = ai_provider
  end
end
