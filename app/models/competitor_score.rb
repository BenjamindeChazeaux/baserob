class CompetitorScore < ApplicationRecord
  belongs_to :competitor
  belongs_to :geo_scoring

  validates :score, :frequency_score, :position_score, :link_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
