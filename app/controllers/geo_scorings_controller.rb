class GeoScoringsController < ApplicationController
  def index
    @geoscoring = GeoScoring.all
  end

  def show
    @geoscoring = GeoScoring.find(params[:id])
  end

  def update
    @geoscoring = GeoScoring.find(params[:id])
    if @geoscoring.update(geo_scoring_params)
      redirect_to @geoscoring
    else
      render 'edit'
    end
  end

  private

  def geo_scoring_params
    params.require(:geo_scoring).permit(:attribute1, :attribute2)
  end
end
