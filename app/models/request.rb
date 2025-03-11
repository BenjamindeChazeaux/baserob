class Request < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider

  validates :company, presence: true
  validates :ai_provider, presence: true
  validates :user_agent, presence: true
  validates :referrer, presence: true
  validates :domain, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp}
  validates :path, presence: true
end
