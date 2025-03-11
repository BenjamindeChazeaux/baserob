class RequestsController < ApplicationController
  def index
    @requests = Request.all

    ai_provider_id_param = params.dig(:search, :ai_provider)
    if ai_provider_id_param.present?
      @ai_provider = AiProvider.find(ai_provider_id_param)
      @requests = @requests.where(ai_provider: @ai_provider)
    end


    # if params[:start_date].present? && params[:end_date].present?
    #   @requests = @requests.where(created_at: params[:start_date]..params[:end_date])
    # elsif params[:start_date].present?
    #   @requests = @requests.where('created_at >= ?', params[:start_date])
    # elsif params[:end_date].present?
    #   @requests = @requests.where('created_at <= ?', params[:end_date])
    # end

    @ai_crawler_requests_count = @requests.count
  end
end

  # def show
  #   @request = Request.find(params[:id])
  # end

#   def update
#     @request = Request.find(params[:id])
#     if @request.update(request_params)
#       redirect_to @request
#     else
#       render :edit
#     end
#   end

#   private

#   def request_params
#     params.require(:request).permit(:attribute1, :attribute2)
#   end
