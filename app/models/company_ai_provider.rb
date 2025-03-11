class CompanyAiProvider < ApplicationRecord
  belongs_to :company
  belongs_to :ai_provider
end
