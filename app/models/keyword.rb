class Keyword < ApplicationRecord
  belongs_to :company

  has_many :geo_scorings

  validates :company, presence: true
  validates :content, presence: true, uniqueness: { scope: :company_id, message: "This keyword is already existed" }

  # Analyse le mot-clé avec tous les fournisseurs d'IA de l'entreprise
  def analyze!
    GeoScoringService.new(self, company).call
  end
end
