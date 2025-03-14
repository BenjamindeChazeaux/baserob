class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    
    if @company.save
      # Associer l'utilisateur actuel à la company créée
      current_user.update(company: @company) if current_user.company.nil?
      
      # Répondre en JSON si c'est une requête AJAX (pour la modal QuickStart)
      respond_to do |format|
        format.html { redirect_to companies_path, notice: "Company was successfully created." }
        format.json { render json: { success: true, message: "Company was successfully created." } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { success: false, message: @company.errors.full_messages.join(", ") } }
      end
    end
  end

  def edit
    @companie = companie.find(params[:id])
  end

  def update
    @companie = companie.find(params[:id])
    if @company.update(company_params)
      redirect_to companies_path, notice: "Company was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: "Company was successfully destroyed."
  end

  private

  def company_params
    params.require(:company).permit(:name, :domain, :description)
  end
end
