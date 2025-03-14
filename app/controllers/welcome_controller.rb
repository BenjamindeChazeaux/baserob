class WelcomeController < ApplicationController
  def index
    @company = Company.new
  end

  def show
  end

  def home
    render 'pages/home'
  end

  def ai_analytics
    render 'ai_analytics/index'
  end

  def geo_scoring
    render 'geo_scorings/index'
  end

  def website_crawling
    render 'website_crawling/index'
  end

  def settings
    render 'settings/index'
  end
end
