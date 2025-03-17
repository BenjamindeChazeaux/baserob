class GeoScoringCalculatorService
  def initialize(company)
    @company = company
  end

  def calculate_position_score(ai_responses)
    return 0 if ai_responses.nil? || ai_responses.empty?

    # Normaliser les réponses et le nom de l'entreprise
    normalized_company_name = @company.name.downcase.strip
    normalized_responses = ai_responses.map { |r| r.downcase.strip }

    # Trouver la meilleure correspondance
    position = normalized_responses.index do |response|
      response.include?(normalized_company_name) ||
      normalized_company_name.include?(response) ||
      calculate_similarity(response, normalized_company_name) > 0.8
    end

    position.nil? ? 0 : (100 - (position.to_f / ai_responses.length * 100)).round(2)
  end

  def calculate_reference_score(ai_responses)
    return 0 if ai_responses.nil? || ai_responses.empty?

    normalized_company_name = @company.name.downcase.strip
    normalized_responses = ai_responses.map { |r| r.downcase.strip }

    # Compter les mentions exactes et similaires
    count = normalized_responses.count do |response|
      response.include?(normalized_company_name) ||
      normalized_company_name.include?(response) ||
      calculate_similarity(response, normalized_company_name) > 0.8
    end

    (count.to_f / ai_responses.length * 100).round(2)
  end

  def check_url_presence(ai_responses)
    return false if ai_responses.nil? || ai_responses.empty?

    normalized_domain = @company.domain.downcase.strip
    normalized_responses = ai_responses.map { |r| r.downcase.strip }

    normalized_responses.any? { |response| response.include?(normalized_domain) }
  end

  def extract_url_from_responses(ai_responses)
    return nil if ai_responses.nil? || ai_responses.empty?

    normalized_domain = @company.domain.downcase.strip
    normalized_responses = ai_responses.map { |r| r.downcase.strip }

    ai_responses[normalized_responses.index { |response| response.include?(normalized_domain) }]
  end

  def calculate_all_scores(ai_responses)
    {
      position_score: calculate_position_score(ai_responses),
      reference_score: calculate_reference_score(ai_responses),
      url_presence: check_url_presence(ai_responses),
      url_value: extract_url_from_responses(ai_responses)
    }
  end

  private

  def calculate_similarity(str1, str2)
    # Algorithme de Levenshtein simplifié pour la similarité
    str1 = str1.downcase
    str2 = str2.downcase

    m = str1.length
    n = str2.length
    return 0 if m == 0 || n == 0

    matrix = Array.new(m + 1) { Array.new(n + 1) }

    (0..m).each { |i| matrix[i][0] = i }
    (0..n).each { |j| matrix[0][j] = j }

    (1..m).each do |i|
      (1..n).each do |j|
        if str1[i-1] == str2[j-1]
          matrix[i][j] = matrix[i-1][j-1]
        else
          matrix[i][j] = [
            matrix[i-1][j-1] + 1,
            matrix[i][j-1] + 1,
            matrix[i-1][j] + 1
          ].min
        end
      end
    end

    max_length = [m, n].max
    return 0 if max_length == 0
    1 - (matrix[m][n].to_f / max_length)
  end
end
