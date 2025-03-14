class GeoScoringCalculatorService
  def initialize(company)
    @company = company
  end

  def calculate_position_score(ai_responses_hash)
    scores = ai_responses_hash.values.map do |ai_responses|
      position = ai_responses.index { |response| response.include?(@company.name) }
      position.nil? ? 0 : (100 / Math.log2(position + 2)).round(2)
    end
    scores.sum / scores.size.to_f
  end

  def calculate_reference_score(ai_responses_hash)
    scores = ai_responses_hash.values.map do |ai_responses|
      count = ai_responses.count { |response| response.include?(@company.name) }
      total = ai_responses.length
      total.zero? ? 0 : ((count.to_f / total) * 100) * (1 + Math.log2(count + 1))
    end
    scores.sum / scores.size.to_f
  end

  def check_url_presence(ai_responses_hash)
    ai_responses_hash.values.any? { |ai_responses| ai_responses.any? { |response| response.include?(@company.domain) } }
  end

  def extract_url_from_responses(ai_responses_hash)
    ai_responses_hash.values.each do |ai_responses|
      url = ai_responses.find { |response| response.include?(@company.domain) }
      return url unless url.nil?
    end
    nil
  end

  def calculate_all_scores(ai_responses_hash)
    {
      position_score: calculate_position_score(ai_responses_hash).round(2),
      reference_score: calculate_reference_score(ai_responses_hash).round(2),
      url_presence: check_url_presence(ai_responses_hash),
      url_value: extract_url_from_responses(ai_responses_hash)
    }
  end
end
