class Company < ApplicationRecord
  has_many :keywords
  has_many :competitors
  has_many :company_ai_providers
  
  validates :name, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
