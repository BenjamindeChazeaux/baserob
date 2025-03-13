class GeoScoring < ApplicationRecord
  attr_accessor :prompt
  belongs_to :ai_provider
  belongs_to :keyword

end
