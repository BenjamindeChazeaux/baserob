class CompanyAiProvider < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider

  validates :company_id, uniqueness: { scope: :ai_provider_id, message: "This company is already following this AI Provider" }
end
