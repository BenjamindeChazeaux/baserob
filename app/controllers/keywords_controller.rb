class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end


  def show
    @keyword = Keyword.find(params[:id])
  end

  def new
    @keyword = Keyword.new
  end



  def create
    @keyword = Keyword.find_or_create_by(content: params[:content], company: current_user.company)

    respond_to do |format|
      if @keyword.persisted?
        format.turbo_stream
        format.html { redirect_to geo_scorings_path, notice: " Added!" }
      else
        format.html { redirect_to geo_scorings_path, alert: "Opps somethioing whent wrong" }
      end
    end
  end


  def edit
    @keyword = Keyword.find(params[:id])
  end

  def update
    @keyword = Keyword.find(params[:id])
    if @keyword.update(keyword_params)
      redirect_to @keyword
    else
      render :edit
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy
    redirect_to keywords_path
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name, :description)
  end
end
