class GeoScoring < ApplicationRecord
  # Associations
  belongs_to :keyword
  belongs_to :ai_provider

  before_save :calculate_position, :calculate_score

  validates :position_score, :url_presence,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :keyword_id, presence: true
  validates :ai_provider_id, presence: true

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
    position_score = position ? (100 - (position * 10)) : 0

    # Pondération des facteurs
    weight_presence = 0.4
    weight_position = 0.6

    ((presence_score * weight_presence) + (position_score * weight_position)).round
  end

  # 3️ Calcul du score global d'un AI Provider pour un mot-clé donné
  def calculate_global_score
    weight_position = 0.5
    weight_url = 0.3
    weight_frequency = 0.2

    global_score = (position_score.to_f * weight_position) +
                   (calculate_url_score * weight_url) +
                   (frequency_score.to_f * weight_frequency)

    global_score.round
  end

  # 4️⃣ Calcul des tendances entre les anciens et les nouveaux scores
  def self.calculate_trends(previous, current)
    return { position_score: nil, frequency_score: nil, url_score: nil } unless previous && current

    {
      position_score: compute_trend(previous.position_score, current.position_score),
      frequency_score: compute_trend(previous.frequency_score, current.frequency_score),
      url_score: compute_trend(previous.calculate_url_score, current.calculate_url_score)
    }
  end

  # 5️⃣ Calcul d'une tendance entre deux valeurs
  def self.compute_trend(previous_value, current_value)
    return nil if previous_value.nil? || current_value.nil?
    return "➡️" if previous_value == current_value
    return "🔼" if current_value > previous_value
    return "🔽" if current_value < previous_value
  end

  # 6️⃣ Calcul de la position et de la mention dans les réponses AI
  def calculate_position
    return if ai_responses.nil? || ai_responses.empty?

    # Préparation des termes de recherche (nom de l'entreprise et domaine)
    company_name = keyword.company.name.downcase.strip
    company_domain = keyword.company.domain.present? ? extract_domain(keyword.company.domain.downcase) : nil

    # Prépare les termes de recherche (mots-clés importants de l'entreprise)
    search_terms = [company_name]
    # Ajoute les mots individuels du nom de l'entreprise s'il y en a plusieurs
    search_terms += company_name.split(/\s+/) if company_name.include?(' ')
    # Ajoute le domaine sans le protocole et www si présent
    search_terms << company_domain if company_domain.present?

    # Normalisation des réponses
    normalized_responses = ai_responses.map { |r| r.to_s.downcase.strip }

    # Trouver la position de l'entreprise dans les réponses
    position_index = normalized_responses.find_index do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    # Vérifier si l'entreprise est mentionnée dans les réponses
    mentioned_in_responses = normalized_responses.any? do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    # Mise à jour des attributs
    self.position = position_index
    self.mentioned = mentioned_in_responses

    # Calcul du position_score
    self.position_score = if position_index.nil?
      0
    else
      (100 - (position_index.to_f / ai_responses.length * 100)).round(2)
    end

    # Fréquence des mentions (compte les occurrences)
    mentions_count = normalized_responses.count do |response|
      search_terms.any? { |term| response.include?(term) }
    end

    self.frequency_score = (mentions_count.to_f / ai_responses.length * 100).round(2)

    # URL présence (vérifie si le domaine est dans les réponses)
    self.url_presence = company_domain.present? && normalized_responses.any? { |r| r.include?(company_domain) }
  end

  private

  # Extraire le domaine de base d'une URL
  def extract_domain(url)
    # Supprime protocole, www, et chemin
    domain = url.gsub(%r{^https?://}, '')
                .gsub(/^www\./, '')
                .split('/').first
    domain
  end

  # 7️⃣ Calcul du score final
  def calculate_score
    return if position_score.nil?

    # Recalcul du score global
    self.score = calculate_global_score
  end
end
