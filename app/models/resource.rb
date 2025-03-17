class Resource < ApplicationRecord
  validates :title, :content, :summary, :published_at, :category, :author, presence: true
  validates :slug, presence: true, uniqueness: true
  
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  
  # Catégories prédéfinies pour les articles GEO
  CATEGORIES = [
    "GEO Basics", 
    "GEO Strategy", 
    "GEO Tools", 
    "Case Studies", 
    "AI & SEO", 
    "Content Optimization"
  ]
  
  # Génère un slug à partir du titre
  def generate_slug
    self.slug = title.parameterize
  end
  
  # Retourne l'URL pour afficher la ressource
  def to_param
    slug
  end
  
  # Calcule le temps de lecture si non spécifié
  def calculate_reading_time
    return reading_time if reading_time.present?
    
    words_per_minute = 200
    word_count = content.split.size
    (word_count / words_per_minute.to_f).ceil
  end
  
  # Retourne une version tronquée du résumé
  def short_summary(length = 150)
    summary.truncate(length, separator: ' ')
  end
end
