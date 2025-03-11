class AiProvider < ApplicationRecord
  has_many :requests
  has_many :company_ai_providers
  has_many :geo_scorings

  validates :name, presence: true, uniqueness: true

end
