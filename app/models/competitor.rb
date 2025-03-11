class Competitor < ApplicationRecord
  belongs_to :company
  has_many :competitor_scores


  validates :name, presence: true
  validates :domain, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

end
