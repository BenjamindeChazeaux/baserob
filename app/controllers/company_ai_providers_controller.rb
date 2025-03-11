class CompanyAiProvidersController < ApplicationController
  def index
    @company_ai_providers = CompanyAiProvider.all
  end

  def show
    @company_ai_provider = CompanyAiProvider.find(params[:id])
  end

  def new
    @company_ai_provider = CompanyAiProvider.new
  end

  def create
    @company_ai_provider = CompanyAiProvider.new(company_ai_provider_params)
    if @company_ai_provider.save
      redirect_to @company_ai_provider, notice: 'Company AI Provider was successfully created.'
    else
      render :new
    end
  end

  def edit
    @company_ai_provider = CompanyAiProvider.find(params[:id])
  end

  def update
    @company_ai_provider = CompanyAiProvider.find(params[:id])
    if @company_ai_provider.update(company_ai_provider_params)
      redirect_to @company_ai_provider, notice: 'Company AI Provider was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @company_ai_provider = CompanyAiProvider.find(params[:id])
    @company_ai_provider.destroy
    redirect_to company_ai_providers_url, notice: 'Company AI Provider was successfully destroyed.'
  end

  private

  def company_ai_provider_params
    params.require(:company_ai_provider).permit(:name, :description)
  end
end
