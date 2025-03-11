class GeoScoringsController < ApplicationController
  def index
  end

  def show
  end

  def update
  end

  private

  def set_geo_scoring
    @geo_scoring = GeoScoring.find(params[:id])
  end
end

