class AiProvidersController < ApplicationController
  def index
    @ai_providers = AiProvider.all
  end

  def show
    @ai_provider = AiProvider.find(params[:id])
  end

  def new
    @ai_provider = AiProvider.new
  end

  def create
    @ai_provider = AiProvider.new(ai_provider_params)
    if @ai_provider.save
      redirect_to ai_providers_path, notice: "AI Provider was successfully created."
    else
      render :new
    end
  end

  def edit
    @ai_provider = AiProvider.find(params[:id])
  end

  def update
    @ai_provider = AiProvider.find(params[:id])
    if @ai_provider.update(ai_provider_params)
      redirect_to ai_providers_path, notice: "AI Provider was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @ai_provider = AiProvider.find(params[:id])
    @ai_provider.destroy
    redirect_to ai_providers_path, notice: "AI Provider was successfully destroyed."
  end
end
