class GeoScoring < ApplicationRecord
  attr_accessor :prompt
  belongs_to :ai_provider
  belongs_to :keyword

  before_save :calculate_position, :calculate_score

  def calculate_score
    self.score = if mentioned?
      position.nil? ? 0 : (1 - (position.to_f / ai_responses.length) * 100).round(2)
    else
      0
    end

    self.score
  end

  private

  def calculate_position
    position = ai_responses.index do |element|
      element.parameterize.include?(keyword.company.name.parameterize)
    end

    self.position = position
  end
end
