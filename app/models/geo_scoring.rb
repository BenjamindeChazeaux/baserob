class GeoScoring < ApplicationRecord
  attr_accessor :prompt
  belongs_to :ai_provider
  belongs_to :keyword

  validates :score, numericality: true, allow_nil: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :mentioned, inclusion: { in: [true, false] }

  before_save :calculate_position, :calculate_score
  after_save :update_keyword_scores

  def calculate_position
    return unless keyword&.company&.name.present? && ai_responses.present?

    normalized_company_name = keyword.company.name.to_s.downcase.strip
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }

    position = normalized_responses.index do |response|
      response.include?(normalized_company_name) ||
      normalized_company_name.include?(response) ||
      calculate_similarity(response, normalized_company_name) > 0.8
    end

    self.position = position
    self.mentioned = position.present?
  end

  def calculate_score
    return 0 unless mentioned && position.present?

    # Score de position (40% du score total)
    position_score = calculate_position_score || 0

    # Score de référence (30% du score total)
    reference_score = calculate_reference_score || 0

    # Score d'URL (20% du score total)
    url_score = calculate_url_score || 0

    # Score de fraîcheur (10% du score total)
    recency_score = calculate_recency_score || 0

    # Calcul du score final pondéré
    self.score = (
      position_score.to_f * 0.4 +
      reference_score.to_f * 0.3 +
      url_score.to_f * 0.2 +
      recency_score.to_f * 0.1
    ).round(2)
  end

  private

  def calculate_position_score
    return 0 unless position.present? && ai_responses.any?

    total_results = ai_responses.length
    position_weight = 1.0 - (position.to_f / total_results)

    # Bonus pour les premières positions
    if position < 3
      position_weight *= 1.2
    elsif position < 5
      position_weight *= 1.1
    end

    (position_weight * 100).round(2)
  end

  def calculate_reference_score
    return 0 unless mentioned

    score = 100.0

    # Vérifier si la mention est exacte
    normalized_company_name = keyword.company.name.to_s.downcase.strip
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }

    exact_match = normalized_responses.any? do |response|
      response == normalized_company_name
    end

    if exact_match
      score += 20
    else
      # Vérifier la similarité
      best_similarity = normalized_responses.map do |response|
        calculate_similarity(response, normalized_company_name)
      end.max || 0

      if best_similarity > 0.8
        score += 10
      end
    end

    score.round(2)
  end

  def calculate_url_score
    return 0 unless url.present?

    score = 100.0

    # Pénalités pour l'URL
    score -= 20 unless url.to_s.start_with?('https://')
    score -= 10 if url.to_s.include?('?') # URL avec paramètres
    score -= 10 if url.to_s.length > 100 # URL trop longue

    score.round(2)
  end

  def calculate_recency_score
    return 0 unless created_at

    days_old = (Time.current - created_at) / 1.day
    [100 - (days_old * 5), 0].max.round(2)
  end

  def calculate_similarity(str1, str2)
    str1 = str1.to_s.downcase
    str2 = str2.to_s.downcase

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

  def update_keyword_scores
    # Calcul avec pondération temporelle
    recent_scorings = keyword.geo_scorings.where('created_at > ?', 30.days.ago)

    # Moyenne pondérée par la fraîcheur des données
    weighted_score = recent_scorings.sum do |scoring|
      weight = calculate_recency_weight(scoring.created_at)
      scoring.score * weight
    end / recent_scorings.sum { |s| calculate_recency_weight(s.created_at) }

    # Calcul de la tendance
    trend = calculate_trend

    keyword.update(
      score: weighted_score,
      frequency_score: calculate_frequency_score,
      position_score: calculate_position_score,
      link_score: calculate_link_score,
      trend: trend
    )
  end

  def calculate_recency_weight(created_at)
    age_in_days = (Time.current - created_at) / 1.day
    [1 - (age_in_days / 30.0), 0].max
  end

  def calculate_trend
    recent_scorings = keyword.geo_scorings.order(created_at: :desc).limit(2)
    return 0 if recent_scorings.length < 2

    current_score = recent_scorings.first.score
    previous_score = recent_scorings.last.score

    ((current_score - previous_score) / previous_score * 100).round(2)
  end

  def calculate_frequency_score
    recent_scorings = keyword.geo_scorings.where('created_at > ?', 30.days.ago)
    return 0 if recent_scorings.empty?

    mentioned_count = recent_scorings.where(mentioned: true).count
    (mentioned_count.to_f / recent_scorings.count * 100).round(2)
  end

  def calculate_link_score
    recent_scorings = keyword.geo_scorings.where('created_at > ?', 30.days.ago)
    return 0 if recent_scorings.empty?

    with_url_count = recent_scorings.where(url_presence: true).count
    (with_url_count.to_f / recent_scorings.count * 100).round(2)
  end
end
