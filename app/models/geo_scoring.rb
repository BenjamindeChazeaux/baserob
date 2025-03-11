class GeoScoring < ApplicationRecord
  belongs_to :keyword
  belongs_to :ai_provider
end
