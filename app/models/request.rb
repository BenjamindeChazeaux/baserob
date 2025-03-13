class Request < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider, optional: true

  validates :company, presence: true
  validates :user_agent, presence: true
  validates :domain, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp}
  validates :path, presence: true

  before_validation :set_ai_provider

  private

  def set_ai_provider
    ai_provider = AiProvider.find_by_referrer(self.referrer)

    self.ai_provider = ai_provider
  end
end
