class CompetitorScoresController < ApplicationController
  def index
    @competitor_scores = CompetitorScore.all
  end

  def show
    @competitor_score = CompetitorScore.find(params[:id])
  end

  def update
    @competitor_score = CompetitorScore.find(params[:id])
    if @competitor_score.update(competitor_score_params)
      redirect_to @competitor_score
    else
      render :edit
    end
  end

  private

  def competitor_score_params
    params.require(:competitor_score).permit(:score, :competitor_id, :event_id)
  end
end
