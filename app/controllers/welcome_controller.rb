class WelcomeController < ApplicationController

  def index
    @company = Company.new

    if current_user&.company.present?
      real_company = current_user.company
      @total_requests_count = real_company.requests.count
      @ai_requests_count = real_company.requests.where.not(ai_provider_id: nil).count
      @non_ai_requests_count = real_company.requests.count - @ai_requests_count
      @ai_requests_percentage = (@ai_requests_count.to_f / @total_requests_count.to_f)
      @ai_not_requests_percentage = (@non_ai_requests_count.to_f / @total_requests_count.to_f)
      
    else
      real_company = nil
      @total_requests_count = 0
      @ai_requests_count = 0
      @non_ai_requests_count = 0
    end
    # @non_ai_requests_count = real_company.requests.count - @ai_requests_count
  end

  def show
  end

  def home
    render 'pages/home'
  end

end
