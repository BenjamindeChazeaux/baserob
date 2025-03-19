class GeoScoring < ApplicationRecord
  belongs_to :keyword
  belongs_to :ai_provider

  before_save :calculate_position, :calculate_score

  validates :position_score, :url_presence,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :keyword_id, presence: true
  validates :ai_provider_id, presence: true

  # Constantes de pondération
  WEIGHTS = {
    position: 0.5,
    url: 0.3,
    frequency: 0.2
  }

  # 1️ Récupération du dernier score précédent pour un mot-clé et un AI Provider
  def self.previous_scoring(keyword_id, ai_provider_id)
    where(keyword_id: keyword_id, ai_provider_id: ai_provider_id)
      .where("created_at < ?", Time.current.beginning_of_day)
      .order(created_at: :desc)
      .first
  end

  # 2️ Calcul du score de l'URL
  def calculate_url_score
    presence_score = url_presence ? 100 : 0

    # Pondération des facteurs
    weight_presence = 0.4
    weight_position = 0.6

    ((presence_score * weight_presence) + (position_score * weight_position)).round
  end

  # 3️ Calcul du score global d'un AI Provider pour un mot-clé donné
  def calculate_global_score
    weight_position = 0.5
    weight_frequency = 0.2

    global_score = (position_score.to_f * weight_position) +
                   (frequency_score.to_f * weight_frequency)

    global_score.round
  end

  # 4️ Calcul des tendances entre les anciens et les nouveaux scores
  def self.calculate_trends(previous, current)
    return { position_score: nil, frequency_score: nil, url_score: nil } unless previous && current

    {
      position_score: compute_trend(previous.position_score, current.position_score),
      frequency_score: compute_trend(previous.frequency_score, current.frequency_score),
      url_score: compute_trend(previous.url_presence ? 100 : 0, current.url_presence ? 100 : 0)
    }
  end

  # 5️ Calcul d'une tendance entre deux valeurs
  def self.compute_trend(previous_value, current_value)
    return nil if previous_value.nil? || current_value.nil?
    return "➡️" if previous_value == current_value
    return "🔼" if current_value > previous_value
    return "🔽" if current_value < previous_value
  end

  # 6️ Calcul de la position et de la mention dans les réponses AI
  def calculate_position
    return if ai_responses.nil? || ai_responses.empty?

    # Préparation des termes de recherche
    company_name = keyword.company.name.downcase.strip
    company_domain = keyword.company.domain.present? ? extract_domain(keyword.company.domain.downcase) : nil

    # Construction des termes de recherche
    search_terms = [company_name]
    search_terms += company_name.split(/\s+/) if company_name.include?(' ')
    search_terms << company_domain if company_domain.present?

    # Normalisation des réponses
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }

    # Trouver la position de l'entreprise
    position_index = normalized_responses.find_index do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    # Vérifier si l'entreprise est mentionnée
    mentioned_in_responses = normalized_responses.any? do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    # Compter les mentions
    mentions_count = normalized_responses.count do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    # Mise à jour des attributs
    self.position = position_index
    self.mentioned = mentioned_in_responses
    self.position_score = calculate_position_score(position_index, ai_responses.length)
    self.frequency_score = calculate_reference_score(mentions_count, ai_responses.length)
    self.url_presence = company_domain.present? && normalized_responses.any? { |r| r.include?(company_domain) }
  end

  private

  # Extraire le domaine de base d'une URL
  def extract_domain(url)
    domain = url.gsub(%r{^https?://}, '')
                .gsub(/^www\./, '')
                .split('/').first
    domain
  end

  # 7️ Calcul du score final
  def calculate_score
    return if position_score.nil?

    self.score = (
      position_score.to_f * WEIGHTS[:position] +
      (url_presence ? 100 : 0) * WEIGHTS[:url] +
      frequency_score.to_f * WEIGHTS[:frequency]
    ).round
  end

  # Calcul du score de position
  def calculate_position_score(position_index, total_responses)
    return 0 if position_index.nil? || total_responses == 0
    (100 - (position_index.to_f / total_responses * 100)).round(2)
  end

  # Calcul du score de référence
  def calculate_reference_score(mentions_count, total_responses)
    return 0 if total_responses == 0
    (mentions_count.to_f / total_responses * 100).round(2)
  end
end

