class GeoScoring < ApplicationRecord
  # Associations
  belongs_to :keyword
  belongs_to :ai_provider

  before_save :calculate_position, :calculate_score

  # private

  def calculate_score
    score = if mentioned?
      position.nil? ? 0 : (100 - (position.to_f / ai_responses.length * 100)).round(2)
    else
      0
    end

    self.score = score
  end

  def calculate_position
    position = ai_responses.index do |element|
      element.parameterize.include?(keyword.company.name.parameterize)
    end

    self.position = position
  end
end
