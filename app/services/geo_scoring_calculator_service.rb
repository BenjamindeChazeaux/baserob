class GeoScoringCalculatorService
  def initialize(company)
    @company = company
  end

  def calculate_position_score(ai_responses)
    return 0 if ai_responses.nil? || ai_responses.empty?
    position = ai_responses.index(@company.name)
    position.nil? ? 0 : (100 - (position.to_f / ai_responses.length * 100)).round(2)
  end

  def calculate_reference_score(ai_responses)
    return 0 if ai_responses.nil? || ai_responses.empty?
    count = ai_responses.count { |response| response.include?(@company.name) }
    (count.to_f / ai_responses.length * 100).round(2)
  end

  def check_url_presence(ai_responses)
    return false if ai_responses.nil? || ai_responses.empty?
    ai_responses.any? { |response| response.include?(@company.domain) }
  end

  def extract_url_from_responses(ai_responses)
    return nil if ai_responses.nil? || ai_responses.empty?
    ai_responses.find { |response| response.include?(@company.domain) }
  end

  def calculate_all_scores(ai_responses)
    {
      position_score: calculate_position_score(ai_responses),
      reference_score: calculate_reference_score(ai_responses),
      url_presence: check_url_presence(ai_responses),
      url_value: extract_url_from_responses(ai_responses)
    }
  end
end
