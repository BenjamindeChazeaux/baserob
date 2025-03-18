class GeoScoring < ApplicationRecord
  # Associations
  belongs_to :keyword
  belongs_to :ai_provider

  # Validations
  validates :position_score, :url_presence,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :keyword_id, presence: true
  validates :ai_provider_id, presence: true

  # 1️⃣ Récupération du dernier score précédent pour un mot-clé et un AI Provider
  def self.previous_scoring(keyword_id, ai_provider_id)
    where(keyword_id: keyword_id, ai_provider_id: ai_provider_id)
      .where("created_at < ?", Time.current.beginning_of_day)
      .order(created_at: :desc)
      .first
  end

  # 2️⃣ Calcul du score de l'URL basé sur plusieurs facteurs
  def calculate_url_score
    presence_score = url_presence ? 100 : 0
    position_score = position ? (100 - (position * 10)) : 0

    # Pondération des facteurs
    weight_presence = 0.4
    weight_position = 0.6

    ((presence_score * weight_presence) + (position_score * weight_position)).round
  end

  # 3️⃣ Calcul du score global d'un AI Provider pour un mot-clé donné
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
end
