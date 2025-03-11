class Competitor < ApplicationRecord
  belongs_to :company
  has_many :competitor_scores
end
