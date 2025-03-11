class GeoScoringsController < ApplicationController
  before_action :set_keyword, only: [:history]

  # 📌 Affiche la liste des scores par AI et le score global
  def index
    @keywords = Keyword.all

    if params[:keyword_id].present?
      @selected_keyword = Keyword.find(params[:keyword_id])
      @position_scores = GeoScoring.where(keyword: @selected_keyword)
                                   .includes(:ai_provider)
                                   .order("geo_scorings.position_score ASC") # 🟢 Trie les scores par position
                                   .limit(3) # 🟢 Sélectionne les 3 premiers AI Providers
    else
      @selected_keyword = nil
      @position_scores = []
    end

    # 🟢 Calcul du score global basé sur les 3 premiers AI
    scores = @position_scores.pluck(:position_score)
    @global_score = scores.present? ? (scores.sum.to_f / scores.size).round(2) : nil
  end
  #  Affiche l'évolution de la position d'un site en fonction d'un mot-clé
  def history
    @history_scores = GeoScoring.where(keyword: @keyword).order(created_at: :asc)

    respond_to do |format|
      format.html { render partial: "history", locals: { history_scores: @history_scores } }
      format.json { render json: @history_scores }
    end
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:keyword_id])
  end
end
