class CompetitorScore < ApplicationRecord
  belongs_to :competitor
  belongs_to :geo_scoring
end
