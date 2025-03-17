class WelcomeController < ApplicationController

  def index
    @company = Company.new

    real_company = Company.first
    @total_requests_count = real_company.requests.count
    @ai_requests_count = real_company.requests.where.not(ai_provider_id: nil).count
    # @non_ai_requests_count = real_company.requests.count - @ai_requests_count

  end

  def show
  end

  def home
    render 'pages/home'
  end

end
