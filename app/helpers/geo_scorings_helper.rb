module GeoScoringsHelper
  def score_color_class(score)
    case score
    when 0..33 then "danger"
    when 34..66 then "warning"
    else "success"
    end
  end
end
