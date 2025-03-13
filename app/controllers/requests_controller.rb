class RequestsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!, only: [:create]
  before_action :authenticate_company!, only: [:create]
  def index

    @company = current_user.company
    @ai_providers = @company.ai_providers
    @requests = @company.requests

    ai_provider_id_param = params.dig(:search, :ai_provider)
    if ai_provider_id_param.present?
      @ai_provider = AiProvider.find(ai_provider_id_param)
      @requests = @requests.where(ai_provider: @ai_provider)
    end

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

    group_method = timeline_param == "today" ? :group_by_hour : :group_by_day


    @requests_by_date_and_ai_provider = @ai_providers.map do |ai_provider|
      {
        name: ai_provider.name || "Other",
        data: @requests.where(ai_provider: ai_provider).send(group_method, :created_at).count
      }
    end.concat([
                {
                  name: "Total",
                  data: @requests.send(group_method, :created_at).count
                },
                {
                  name: "Other",
                  data: @requests.where(ai_provider: nil).send(group_method, :created_at).count
                }
              ])
  end

  def create
    @req = Request.new(params_request)
    @req.company = @company
    @req.save!
    render :head
  end

  private

  def params_request
    params.require(:request).permit(:domain, :path, :referrer, :user_agent)
  end

  def authenticate_company!
    @company = Company.find_by(token: request.headers['Authorization'].split.last)
    if @company.nil?
      render json: {error: 'Unauthorized'}, status: :unauthorized
    end
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
