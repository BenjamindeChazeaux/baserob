class KeywordsController < ApplicationController
  before_action :set_company, only: [:index, :create]

  def index
    @keywords = @company.keywords
  end

  def create
    @keyword = @company.keywords.build(keyword_params)

    if @keyword.save
      respond_to do |format|
        format.json { render json: { id: @keyword.id, content: @keyword.content }, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { error: @keyword.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def keyword_params
    params.require(:keyword).permit(:content)
  end
end
