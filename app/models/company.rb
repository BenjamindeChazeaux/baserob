class Company < ApplicationRecord

  has_many :users
  has_many :competitors
  has_many :requests
  has_many :company_ai_providers
  has_many :keywords

  validates :name, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

end
