class Request < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider, optional: true

  validates :company, presence: true
  validates :user_agent, presence: true
  validates :domain, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp}
  validates :path, presence: true

  before_validation :set_ai_provider
  after_create :broadcast_request
  after_create_commit :broadcast_requests

  private

  def broadcast_requests

    top_ai_provider = self.company.ai_providers
      .joins(:requests)
      .where(requests: { company_id: self.company.id })
      .group('ai_providers.id')
      .order('COUNT(requests.id) DESC')
      .first

    top_ai_count = top_ai_provider ? self.company.requests.where(ai_provider: top_ai_provider).count : 0
    broadcast_replace_to "requests",
                        partial: "requests/requests",
                        target: "requests_list",
                        locals: { company: self.company, top_ai_count: top_ai_count, top_ai_provider: top_ai_provider }
  end

  def set_ai_provider
    ai_provider = AiProvider.find_by_referrer(self.referrer)

    self.ai_provider = ai_provider
  end

  def broadcast_request
    CompanyChannel.broadcast_to company, { updated: true }
  end
end
