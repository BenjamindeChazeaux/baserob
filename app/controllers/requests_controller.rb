class RequestsController < ApplicationController
  def index
    @requests = Request.all

    # search AI Provider
    ai_provider_id_param = params.dig(:search, :ai_provider)
    if ai_provider_id_param.present?
      @ai_provider = AiProvider.find(ai_provider_id_param)
      @requests = @requests.where(ai_provider: @ai_provider)
    end


    #search for timeline
    timeline_param = params.dig(:search, :timeline)
    if timeline_param.present?
       case timeline_param
       when "today"
        @requests = @requests.where("created_at >= ?", Date.today)
       when "1_week"
        @requests = @requests.where("created_at >= ?", 1.week.ago)
       when "1_month"
        @requests = @requests.where("created_at >= ?", 1.month.ago)
       when "3_months"
        @requests = @requests.where("created_at >= ?", 3.months.ago)
       when "6_months"
        @requests = @requests.where("created_at >= ?", 6.months.ago)
       end
    end

    @ai_crawler_requests_count = @requests.count # calcul the requests
    @requests_by_date = @requests.group_by_day(:created_at).count
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
