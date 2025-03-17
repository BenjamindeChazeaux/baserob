class WelcomeController < ApplicationController
  def index
    @company = Company.new
  end

  def show
  end

  def home
    render 'pages/home'
  end

end
