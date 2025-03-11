class Company < ApplicationRecord
  has_many :users
  has_many :competitors
  has_many :requests
  has_many :company_ai_providers
  has_many :keywords

  
end
