class Keyword < ApplicationRecord
  belongs_to :company

  has_many :geo_scorings

  validates :company, presence: true
  validates :content, presence: true, uniqueness: { scope: :company_id, message: "This keyword is already existed" }

  def score_trend(geo_scorings)
    return nil if geo_scorings.empty?

    last_week_geo_scorings = geo_scorings.where(created_at: (14.days.ago..7.days.ago))
    current_week_geo_scorings = geo_scorings.where(created_at: (7.days.ago..Date.today))

    last_week_mention_score = last_week_geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100
    last_week_position_score = last_week_geo_scorings.average(:score).to_f
    last_week_url_presence_score = last_week_geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100
    current_week_mention_score = current_week_geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100
    current_week_position_score = current_week_geo_scorings.average(:score).to_f
    current_week_url_presence_score = current_week_geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100

    last_week_score = (last_week_mention_score + last_week_position_score + last_week_url_presence_score) / 3
    current_week_score = (current_week_mention_score + current_week_position_score + current_week_url_presence_score) / 3

    return "=" if (last_week_score - current_week_score).abs < 0.02
    return "↑" if last_week_score < current_week_score
    return "↓" if last_week_score > current_week_score
  end

  def global_score_trend
    geo_scorings = self.geo_scorings
    score_trend(geo_scorings)
  end

  def ai_provider_score_trend(ai_provider)
    geo_scorings = self.geo_scorings.where(ai_provider: ai_provider)
    score_trend(geo_scorings)
  end

  def mention_score_trend(geo_scorings)
    return nil if geo_scorings.empty?

    last_week_geo_scorings = geo_scorings.where(created_at: (14.days.ago..7.days.ago))
    current_week_geo_scorings = geo_scorings.where(created_at: (7.days.ago..Date.today))

    last_week_score = last_week_geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100
    current_week_score = current_week_geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100

    ratio = (((current_week_score - last_week_score) / last_week_score) * 100).round

    return "= #{ratio}" if last_week_score == current_week_score
    return "↑ #{ratio}" if last_week_score < current_week_score
    return "↓ #{ratio}" if last_week_score > current_week_score
  end

  def global_mention_score_trend
    geo_scorings = self.geo_scorings
    mention_score_trend(geo_scorings)
  end

  def ai_provider_mention_score_trend(ai_provider)
    geo_scorings = self.geo_scorings.where(ai_provider: ai_provider)
    mention_score_trend(geo_scorings)
  end


  def position_score_trend(geo_scorings)
    return nil if geo_scorings.empty?

    last_week_geo_scorings = geo_scorings.where(created_at: (14.days.ago..7.days.ago))
    current_week_geo_scorings = geo_scorings.where(created_at: (7.days.ago..Date.today))

    last_week_score = last_week_geo_scorings.average(:score).to_f
    current_week_score = current_week_geo_scorings.average(:score).to_f

    ratio = (((current_week_score - last_week_score) / last_week_score) * 100).round

    return "= #{ratio}" if last_week_score == current_week_score
    return "↑ #{ratio}" if last_week_score < current_week_score
    return "↓ #{ratio}" if last_week_score > current_week_score
  end


  def global_position_score_trend
    geo_scorings = self.geo_scorings
    position_score_trend(geo_scorings)
  end

  def ai_provider_position_score_trend(ai_provider)
    geo_scorings = self.geo_scorings.where(ai_provider: ai_provider)
    position_score_trend(geo_scorings)
  end

  def url_presence_score_trend(geo_scorings)
    return nil if geo_scorings.empty?

    last_week_geo_scorings = geo_scorings.where(created_at: (14.days.ago..7.days.ago))
    current_week_geo_scorings = geo_scorings.where(created_at: (7.days.ago..Date.today))

    last_week_score = last_week_geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100
    current_week_score = current_week_geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100

    ratio = (((current_week_score - last_week_score) / last_week_score) * 100).round

    return "= #{ratio}" if last_week_score == current_week_score
    return "↑ #{ratio}" if last_week_score < current_week_score
    return "↓ #{ratio}" if last_week_score > current_week_score
  end

  def global_url_presence_score_trend
    geo_scorings = self.geo_scorings
    url_presence_score_trend(geo_scorings)
  end

  def ai_provider_url_presence_score_trend(ai_provider)
    geo_scorings = self.geo_scorings.where(ai_provider: ai_provider)
    url_presence_score_trend(geo_scorings)
  end
end
