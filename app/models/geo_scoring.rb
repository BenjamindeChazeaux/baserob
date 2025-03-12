class GeoScoring < ApplicationRecord
  attr_accessor :prompt
  belongs_to :ai_provider
  belongs_to :keyword
  
end

  # def calculate_geoscore
  #   frequency_score_weight = 0.3
  #   position_score_weight = 0.4
  #   link_score_weight = 0.2
  #   ai_score_weight = 0.1

  #   ai_provider_score = ai_provider.average(:ranking).to_f : 0

  #   total_score = (
  #     (frequency_score * frequency_score_weight) +
  #     (position_score * position_score_weight) +
  #     (link_score * link_score_weight) +
  #     (ai_provider_score * ai_score_weight)
  #   ).round(2)

  #   total_score
  # end
