class GeoScoring < ApplicationRecord
  belongs_to :keyword
  belongs_to :ai_provider
  has_many :competitor_scores

  validates :keyword, presence: true
  validates :ai_provider, presence: true
  validates :score, :frequency_score, :position_score, :link_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
