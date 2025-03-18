class GeoScoringCalculatorService
  def initialize(company)
    @company = company
  end

  # Calcule tous les scores pour un ensemble de réponses
  def calculate_all_scores(ai_responses)
    return {
      position_score: 0,
      reference_score: 0,
      url_presence: false,
      url_value: nil
    } if ai_responses.blank?

    # Préparation des termes de recherche
    company_name = @company.name.downcase.strip
    company_domain = @company.domain.present? ? extract_domain(@company.domain.downcase) : nil

    # Préparer les termes de recherche
    search_terms = [company_name]
    search_terms += company_name.split(/\s+/) if company_name.include?(' ')
    search_terms << company_domain if company_domain.present?

    # Normalisation des réponses
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }

    # Calculs des scores
    position = find_position(normalized_responses, search_terms)
    mentions_count = count_mentions(normalized_responses, search_terms)
    url_present = company_domain.present? && normalized_responses.any? { |r| r.include?(company_domain) }
    url_value = url_present ? extract_url(ai_responses, company_domain) : nil

    {
      position_score: calculate_position_score(position, ai_responses.size),
      reference_score: calculate_reference_score(mentions_count, ai_responses.size),
      url_presence: url_present,
      url_value: url_value
    }
  end

  private

  # Extraire le domaine d'une URL
  def extract_domain(url)
    domain = url.gsub(%r{^https?://}, '')
                .gsub(/^www\./, '')
                .split('/').first
    domain
  end

  # Trouver la position de l'entreprise dans les réponses
  def find_position(normalized_responses, search_terms)
    normalized_responses.find_index do |response|
      search_terms.any? { |term| response.include?(term) }
    end
  end

  # Compter les mentions de l'entreprise
  def count_mentions(normalized_responses, search_terms)
    normalized_responses.count do |response|
      search_terms.any? { |term| response.include?(term) }
    end
  end

  # Extraire l'URL de l'entreprise
  def extract_url(ai_responses, company_domain)
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }
    index = normalized_responses.find_index { |r| r.include?(company_domain) }
    index ? ai_responses[index] : nil
  end

  # Calcul du score de position
  def calculate_position_score(position, total_responses)
    return 0 if position.nil? || total_responses == 0
    ((position + 1) * 100.0 / total_responses).round(2)
  end

  # Calcul du score de référence
  def calculate_reference_score(mentions_count, total_responses)
    (mentions_count * 100.0 / total_responses).round(2)
  end
end
