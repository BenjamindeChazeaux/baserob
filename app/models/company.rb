class Company < ApplicationRecord

  has_many :users
  has_many :competitors
  has_many :requests
  has_many :company_ai_providers
  has_many :ai_providers, through: :company_ai_providers
  has_many :keywords

  validates :name, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  before_validation :generate_token

  private

  def generate_token
    return if self.token.present?

    self.token = SecureRandom.hex(16)
  end
end
