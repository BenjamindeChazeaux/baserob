class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
  end

  def show
    @competitor = Competitor.find(params[:id])
  end

  def new
    @competitor = Competitor.new
  end

  def create
    @competitor = Competitor.new(competitor_params)
    if @competitor.save
      redirect_to competitors_path, notice: "Competitor was successfully created."
    else
      render :new
    end
  end

  def edit
    @competitor = Competitor.find(params[:id])
  end

  def update
    @competitor = Competitor.find(params[:id])
    if @competitor.update(competitor_params)
      redirect_to competitors_path, notice: "Competitor was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @competitor = Competitor.find(params[:id])
    @competitor.destroy
    redirect_to competitors_path, notice: "Competitor was successfully destroyed."
  end

  private

  def competitor_params
    params.require(:competitor).permit(:name, :domain, :company)
  end
end
